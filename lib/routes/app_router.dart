import 'package:auto_route/auto_route.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/routes/guards/auth_guard.dart';
import 'package:mondongo/view/screens/qr_scan_page.dart';
import 'package:mondongo/view/screens/qr_reader_page.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: HomeRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(page: RegisterEmpleadoRoute.page),
        AutoRoute(page: RegisterDuenoSupervisorRoute.page),
        AutoRoute(page: RegisterClienteRoute.page),
        AutoRoute(page: RegisterMesaRoute.page),
        AutoRoute(page: AprobacionClientesRoute.page),
        AutoRoute(page: QrScannerRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: MesaRoute.page, guards: [AuthGuard()]),
      ];
}
