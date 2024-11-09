import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mondongo/main.dart';
import 'package:mondongo/models/dueno_supervisor.dart';
import 'package:mondongo/models/empleado.dart';
import 'package:mondongo/models/profile.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late AuthService _authService;

  // Add your backend URL from environment variables
  final String _backendUrl = 'https://push-production.up.railway.app';

  /// Initialize the notification service
  Future<void> initNotifications() async {
    try {
      _authService = getIt.get<AuthService>();
      // Request notification permissions
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('Notification permissions authorized');

        // Get FCM token
        final token = await _firebaseMessaging.getToken();
        if (token != null) {
          debugPrint('FCM Token: $token');
          await _registerDeviceToken(token);
        }

        // Listen for token refresh
        _firebaseMessaging.onTokenRefresh.listen(_registerDeviceToken);

        // Subscribe to relevant topics
        await subscribeToTopics();

        // Register background message handler
        FirebaseMessaging.onBackgroundMessage(
            _firebaseMessagingBackgroundHandler);

        // Set up foreground and background message handlers
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
        FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

        // Handle initial message if app was opened from notification
        final initialMessage = await _firebaseMessaging.getInitialMessage();
        if (initialMessage != null) {
          _handleMessageOpenedApp(initialMessage);
        }
      } else {
        debugPrint('Notification permissions denied');
      }
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  /// Register device token with backend
  Future<void> _registerDeviceToken(String token) async {
    try {
      final Profile? profile = _authService.profile;
      final User? user = _authService.getUser();

      if (user != null) {
        // You might want to store the token in your backend or Supabase
        // This is just an example of how you might do it
        await Supabase.instance.client.from('device_tokens').upsert({
          'user_id': user.id,
          'token': token,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      debugPrint('Error registering device token: $e');
    }
  }

  /// Subscribe user to topics
  Future<void> subscribeToTopics() async {
    try {
      final Profile? profile = _authService.profile;
      final User? user = _authService.getUser();
      final token = await _firebaseMessaging.getToken();

      if (token == null) {
        debugPrint('No FCM token available');
        return;
      }

      // Subscribe to general topic
      await _subscribeToTopic(['all'], token);

      // Subscribe based on user role
      if (profile is DuenoSupervisor) {
        await _subscribeToTopic(['dueno_supervisor'], token);
      } else if (profile is Empleado) {
        await _subscribeToTopic([profile.tipoEmpleado], token);
      }

      // Subscribe to user-specific topic
      if (user != null) {
        await _subscribeToTopic([user.id], token);
      }
    } catch (e) {
      debugPrint('Error subscribing to topics: $e');
    }
  }

  /// Subscribe to a specific topic using backend API
  Future<void> _subscribeToTopic(List<String> topics, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendUrl/api/subscribe'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tokens': [token],
          'topic': topics.first, // Your backend expects a single topic
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Successfully subscribed to topics: $topics');
      } else {
        debugPrint('Failed to subscribe to topics: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error calling subscribe API: $e');
    }
  }

  /// Unsubscribe from topics
  Future<void> unsubscribeFromTopics() async {
    try {
      final Profile? profile = _authService.profile;
      final User? user = _authService.getUser();

      await _firebaseMessaging.unsubscribeFromTopic('all');

      if (profile is DuenoSupervisor) {
        await _firebaseMessaging.unsubscribeFromTopic('dueno_supervisor');
      } else if (profile is Empleado) {
        await _firebaseMessaging.unsubscribeFromTopic(profile.tipoEmpleado);
      }

      if (user != null) {
        await _firebaseMessaging.unsubscribeFromTopic(user.id);
      }

      debugPrint('Successfully unsubscribed from all topics');
    } catch (e) {
      debugPrint('Error unsubscribing from topics: $e');
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Received foreground message: ${message.notification?.title}');
    // Here you can show a dialog, snackbar, or custom notification UI
    // You might want to use a state management solution to update the UI
  }

  /// Handle when app is opened from notification
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('App opened from notification: ${message.notification?.title}');
    // Navigate to specific screen based on notification data
    // You might want to use your navigation service or route management solution
    if (message.data.containsKey('route')) {
      // Navigate to the specified route
      // Example: navigationService.navigateTo(message.data['route']);
    }
  }

  Future<bool> sendNotification({
    required String topic,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendUrl/api/notify'),
        headers: {
          'Content-Type': 'application/json',
          // Aquí puedes añadir headers de autorización si son necesarios
          // 'Authorization': 'Bearer ${_authService.getToken()}'
        },
        body: jsonEncode({
          'topic': topic,
          'title': title,
          'body': body,
          'data': data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        debugPrint(
            'Notification sent successfully: ${responseData['messageId']}');
        return true;
      } else {
        debugPrint('Failed to send notification: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error sending notification: $e');
      return false;
    }
  }
}

/// Global background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.notification?.title}');
  // Perform background tasks if needed
}
