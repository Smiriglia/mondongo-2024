import 'package:auto_route/auto_route.dart';
import 'package:mondongo/main.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/services/auth_services.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    // resolver.next(true);
    // return;
    AuthService authService = getIt.get<AuthService>();
    DataService dataService = getIt.get<DataService>();
    User? user = authService.getUser();
    if (user != null) {
      if (!user.isAnonymous && authService.profile == null) {
        authService.profile = await dataService.fetchProfileById(user.id);
        if (authService.profile != null) {
          resolver.next(true);
        } else {
          router.push(LoginRoute(onResult: (result) async {
            if (result) {
              user = authService.getUser();
              if (user != null) {
                router.removeLast();
                resolver.next(true);
              }
            }
          }));
        }
      } else {
        resolver.next(true);
      }
    } else {
      router.push(LoginRoute(onResult: (result) async {
        if (result) {
          user = authService.getUser();
          if (user != null) {
            router.removeLast();
            resolver.next(true);
          }
        }
      }));
    }
  }
}
