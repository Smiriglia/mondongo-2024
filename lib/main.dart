import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:mondongo/firebase_options.dart';
import 'package:mondongo/routes/app_router.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mondongo/services/email_service.dart';
import 'package:mondongo/services/push_notification_service.dart';
import 'package:mondongo/services/qr_service.dart';
import 'package:mondongo/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

GetIt getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error loading .env file: $e");
  }

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_KEY'] ?? '',
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  
  getIt.registerSingleton(AppRouter());
  getIt.registerSingleton(AuthService());
  getIt.registerSingleton(DataService());
  getIt.registerSingleton(StorageService());
  getIt.registerSingleton(QRService());
  getIt.registerSingleton(EmailService());
  getIt.registerSingleton(PushNotificationService());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppRouter appRouter = getIt.get<AppRouter>();

    return MaterialApp.router(
      title: 'Mondongo',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.config(),
    );
  }
}
