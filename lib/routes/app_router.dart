import 'package:auto_route/auto_route.dart';
import 'package:mondongo/routes/app_router.gr.dart';
import 'package:mondongo/routes/guards/auth_guard.dart';

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
        AutoRoute(page: WaitingToBeAssignedRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: PedidosListRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: CreateProductRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: CustomerQueryRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: WaiterQueriesRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: ProductsListRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: ConfirmacionMozoRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: EstatoPedidoRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: GamesRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: NumberGuessingGameRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: QuizGameRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: TappingGameRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: SurveyRouteRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: SurveyResultsRoute.page, guards: [AuthGuard()]),
        AutoRoute(page: RealizarPedidosRoute.page, guards: [AuthGuard()]),
      ];
}
