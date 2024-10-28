import 'package:auto_route/auto_route.dart';
import 'package:mondongo/routes/guards/auth_guard.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true, guards: [AuthGuard()]),
        AutoRoute(page: LoginRoute.page),
      ];
}
