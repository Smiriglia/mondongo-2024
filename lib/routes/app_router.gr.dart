// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i29;
import 'package:flutter/material.dart' as _i30;
import 'package:mondongo/models/mesa.dart' as _i32;
import 'package:mondongo/models/pedido.dart' as _i31;
import 'package:mondongo/view/screens/aprobacionClientes.dart' as _i1;
import 'package:mondongo/view/screens/confirmacionMozo.dart' as _i3;
import 'package:mondongo/view/screens/create_product_page.dart' as _i4;
import 'package:mondongo/view/screens/customer_query_page.dart' as _i5;
import 'package:mondongo/view/screens/estadoPedido.dart' as _i6;
import 'package:mondongo/view/screens/games_screen.dart' as _i7;
import 'package:mondongo/view/screens/home.dart' as _i8;
import 'package:mondongo/view/screens/login.dart' as _i9;
import 'package:mondongo/view/screens/mesa_page.dart' as _i10;
import 'package:mondongo/view/screens/number_guessing_game.dart' as _i11;
import 'package:mondongo/view/screens/PaymentScreen.dart' as _i12;
import 'package:mondongo/view/screens/PedidosListPage.dart' as _i13;
import 'package:mondongo/view/screens/products_list_page.dart' as _i14;
import 'package:mondongo/view/screens/qr_scan_page.dart' as _i15;
import 'package:mondongo/view/screens/quiz_game.dart' as _i16;
import 'package:mondongo/view/screens/realizar_pedidos.dart' as _i17;
import 'package:mondongo/view/screens/register.dart' as _i22;
import 'package:mondongo/view/screens/register_cliente.dart' as _i18;
import 'package:mondongo/view/screens/register_dueno_supervisor.dart' as _i19;
import 'package:mondongo/view/screens/register_empleado.dart' as _i20;
import 'package:mondongo/view/screens/register_mesa.dart' as _i21;
import 'package:mondongo/view/screens/splash.dart' as _i23;
import 'package:mondongo/view/screens/survey_results_screen.dart' as _i24;
import 'package:mondongo/view/screens/survey_screen.dart' as _i25;
import 'package:mondongo/view/screens/tapping_game.dart' as _i26;
import 'package:mondongo/view/screens/waiter_queries_page.dart' as _i27;
import 'package:mondongo/view/screens/waiting_to_be_assigned_page.dart' as _i28;

/// generated route for
/// [_i1.AprobacionClientesPage]
class AprobacionClientesRoute extends _i29.PageRouteInfo<void> {
  const AprobacionClientesRoute({List<_i29.PageRouteInfo>? children})
      : super(
          AprobacionClientesRoute.name,
          initialChildren: children,
        );

  static const String name = 'AprobacionClientesRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i1.AprobacionClientesPage();
    },
  );
}

/// generated route for
/// [_i2.CerrarPage]

class CerrarRouteArgs {
  const CerrarRouteArgs({
    this.key,
    required this.pedido,
  });

  final _i30.Key? key;

  final _i31.Pedido pedido;

  @override
  String toString() {
    return 'CerrarRouteArgs{key: $key, pedido: $pedido}';
  }
}

/// generated route for
/// [_i3.ConfirmacionMozoPage]
class ConfirmacionMozoRoute extends _i29.PageRouteInfo<void> {
  const ConfirmacionMozoRoute({List<_i29.PageRouteInfo>? children})
      : super(
          ConfirmacionMozoRoute.name,
          initialChildren: children,
        );

  static const String name = 'ConfirmacionMozoRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i3.ConfirmacionMozoPage();
    },
  );
}

/// generated route for
/// [_i4.CreateProductPage]
class CreateProductRoute extends _i29.PageRouteInfo<void> {
  const CreateProductRoute({List<_i29.PageRouteInfo>? children})
      : super(
          CreateProductRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateProductRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i4.CreateProductPage();
    },
  );
}

/// generated route for
/// [_i5.CustomerQueryPage]
class CustomerQueryRoute extends _i29.PageRouteInfo<void> {
  const CustomerQueryRoute({List<_i29.PageRouteInfo>? children})
      : super(
          CustomerQueryRoute.name,
          initialChildren: children,
        );

  static const String name = 'CustomerQueryRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i5.CustomerQueryPage();
    },
  );
}

/// generated route for
/// [_i6.EstatoPedidoPage]
class EstatoPedidoRoute extends _i29.PageRouteInfo<EstatoPedidoRouteArgs> {
  EstatoPedidoRoute({
    _i30.Key? key,
    required _i31.Pedido pedido,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          EstatoPedidoRoute.name,
          args: EstatoPedidoRouteArgs(
            key: key,
            pedido: pedido,
          ),
          initialChildren: children,
        );

  static const String name = 'EstatoPedidoRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EstatoPedidoRouteArgs>();
      return _i6.EstatoPedidoPage(
        key: args.key,
        pedido: args.pedido,
      );
    },
  );
}

class EstatoPedidoRouteArgs {
  const EstatoPedidoRouteArgs({
    this.key,
    required this.pedido,
  });

  final _i30.Key? key;

  final _i31.Pedido pedido;

  @override
  String toString() {
    return 'EstatoPedidoRouteArgs{key: $key, pedido: $pedido}';
  }
}

/// generated route for
/// [_i7.GamesScreen]
class GamesRoute extends _i29.PageRouteInfo<GamesRouteArgs> {
  GamesRoute({
    _i30.Key? key,
    required _i31.Pedido pedido,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          GamesRoute.name,
          args: GamesRouteArgs(
            key: key,
            pedido: pedido,
          ),
          initialChildren: children,
        );

  static const String name = 'GamesRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GamesRouteArgs>();
      return _i7.GamesScreen(
        key: args.key,
        pedido: args.pedido,
      );
    },
  );
}

class GamesRouteArgs {
  const GamesRouteArgs({
    this.key,
    required this.pedido,
  });

  final _i30.Key? key;

  final _i31.Pedido pedido;

  @override
  String toString() {
    return 'GamesRouteArgs{key: $key, pedido: $pedido}';
  }
}

/// generated route for
/// [_i8.HomePage]
class HomeRoute extends _i29.PageRouteInfo<void> {
  const HomeRoute({List<_i29.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i8.HomePage();
    },
  );
}

/// generated route for
/// [_i9.LoginPage]
class LoginRoute extends _i29.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i30.Key? key,
    required dynamic Function(bool) onResult,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onResult: onResult,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>();
      return _i9.LoginPage(
        key: args.key,
        onResult: args.onResult,
      );
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    required this.onResult,
  });

  final _i30.Key? key;

  final dynamic Function(bool) onResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i10.MesaPage]
class MesaRoute extends _i29.PageRouteInfo<MesaRouteArgs> {
  MesaRoute({
    _i30.Key? key,
    required _i32.Mesa mesa,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          MesaRoute.name,
          args: MesaRouteArgs(
            key: key,
            mesa: mesa,
          ),
          initialChildren: children,
        );

  static const String name = 'MesaRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MesaRouteArgs>();
      return _i10.MesaPage(
        key: args.key,
        mesa: args.mesa,
      );
    },
  );
}

class MesaRouteArgs {
  const MesaRouteArgs({
    this.key,
    required this.mesa,
  });

  final _i30.Key? key;

  final _i32.Mesa mesa;

  @override
  String toString() {
    return 'MesaRouteArgs{key: $key, mesa: $mesa}';
  }
}

/// generated route for
/// [_i11.NumberGuessingGameRoute]
class NumberGuessingGameRoute
    extends _i29.PageRouteInfo<NumberGuessingGameRouteArgs> {
  NumberGuessingGameRoute({
    _i30.Key? key,
    required double difficulty,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          NumberGuessingGameRoute.name,
          args: NumberGuessingGameRouteArgs(
            key: key,
            difficulty: difficulty,
          ),
          initialChildren: children,
        );

  static const String name = 'NumberGuessingGameRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NumberGuessingGameRouteArgs>();
      return _i11.NumberGuessingGameRoute(
        key: args.key,
        difficulty: args.difficulty,
      );
    },
  );
}

class NumberGuessingGameRouteArgs {
  const NumberGuessingGameRouteArgs({
    this.key,
    required this.difficulty,
  });

  final _i30.Key? key;

  final double difficulty;

  @override
  String toString() {
    return 'NumberGuessingGameRouteArgs{key: $key, difficulty: $difficulty}';
  }
}

/// generated route for
/// [_i12.PaymentPage]
class PaymentRoute extends _i29.PageRouteInfo<PaymentRouteArgs> {
  PaymentRoute({
    _i30.Key? key,
    required _i31.Pedido pedido,
    required double discount,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          PaymentRoute.name,
          args: PaymentRouteArgs(
            key: key,
            pedido: pedido,
            discount: discount,
          ),
          initialChildren: children,
        );

  static const String name = 'PaymentRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PaymentRouteArgs>();
      return _i12.PaymentPage(
        key: args.key,
        pedido: args.pedido,
        discount: args.discount,
      );
    },
  );
}

class PaymentRouteArgs {
  const PaymentRouteArgs({
    this.key,
    required this.pedido,
    required this.discount,
  });

  final _i30.Key? key;

  final _i31.Pedido pedido;

  final double discount;

  @override
  String toString() {
    return 'PaymentRouteArgs{key: $key, pedido: $pedido, discount: $discount}';
  }
}

/// generated route for
/// [_i13.PedidosListPage]
class PedidosListRoute extends _i29.PageRouteInfo<void> {
  const PedidosListRoute({List<_i29.PageRouteInfo>? children})
      : super(
          PedidosListRoute.name,
          initialChildren: children,
        );

  static const String name = 'PedidosListRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return _i13.PedidosListPage();
    },
  );
}

/// generated route for
/// [_i14.ProductsListPage]
class ProductsListRoute extends _i29.PageRouteInfo<ProductsListRouteArgs> {
  ProductsListRoute({
    _i30.Key? key,
    required _i31.Pedido pedido,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          ProductsListRoute.name,
          args: ProductsListRouteArgs(
            key: key,
            pedido: pedido,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductsListRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductsListRouteArgs>();
      return _i14.ProductsListPage(
        key: args.key,
        pedido: args.pedido,
      );
    },
  );
}

class ProductsListRouteArgs {
  const ProductsListRouteArgs({
    this.key,
    required this.pedido,
  });

  final _i30.Key? key;

  final _i31.Pedido pedido;

  @override
  String toString() {
    return 'ProductsListRouteArgs{key: $key, pedido: $pedido}';
  }
}

/// generated route for
/// [_i15.QrScannerPage]
class QrScannerRoute extends _i29.PageRouteInfo<void> {
  const QrScannerRoute({List<_i29.PageRouteInfo>? children})
      : super(
          QrScannerRoute.name,
          initialChildren: children,
        );

  static const String name = 'QrScannerRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i15.QrScannerPage();
    },
  );
}

/// generated route for
/// [_i16.QuizGameRoute]
class QuizGameRoute extends _i29.PageRouteInfo<QuizGameRouteArgs> {
  QuizGameRoute({
    _i30.Key? key,
    required double difficulty,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          QuizGameRoute.name,
          args: QuizGameRouteArgs(
            key: key,
            difficulty: difficulty,
          ),
          initialChildren: children,
        );

  static const String name = 'QuizGameRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuizGameRouteArgs>();
      return _i16.QuizGameRoute(
        key: args.key,
        difficulty: args.difficulty,
      );
    },
  );
}

class QuizGameRouteArgs {
  const QuizGameRouteArgs({
    this.key,
    required this.difficulty,
  });

  final _i30.Key? key;

  final double difficulty;

  @override
  String toString() {
    return 'QuizGameRouteArgs{key: $key, difficulty: $difficulty}';
  }
}

/// generated route for
/// [_i17.RealizarPedidosPage]
class RealizarPedidosRoute extends _i29.PageRouteInfo<void> {
  const RealizarPedidosRoute({List<_i29.PageRouteInfo>? children})
      : super(
          RealizarPedidosRoute.name,
          initialChildren: children,
        );

  static const String name = 'RealizarPedidosRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i17.RealizarPedidosPage();
    },
  );
}

/// generated route for
/// [_i18.RegisterClientePage]
class RegisterClienteRoute extends _i29.PageRouteInfo<void> {
  const RegisterClienteRoute({List<_i29.PageRouteInfo>? children})
      : super(
          RegisterClienteRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterClienteRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i18.RegisterClientePage();
    },
  );
}

/// generated route for
/// [_i19.RegisterDuenoSupervisorPage]
class RegisterDuenoSupervisorRoute extends _i29.PageRouteInfo<void> {
  const RegisterDuenoSupervisorRoute({List<_i29.PageRouteInfo>? children})
      : super(
          RegisterDuenoSupervisorRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterDuenoSupervisorRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return _i19.RegisterDuenoSupervisorPage();
    },
  );
}

/// generated route for
/// [_i20.RegisterEmpleadoPage]
class RegisterEmpleadoRoute extends _i29.PageRouteInfo<void> {
  const RegisterEmpleadoRoute({List<_i29.PageRouteInfo>? children})
      : super(
          RegisterEmpleadoRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterEmpleadoRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return _i20.RegisterEmpleadoPage();
    },
  );
}

/// generated route for
/// [_i21.RegisterMesaPage]
class RegisterMesaRoute extends _i29.PageRouteInfo<void> {
  const RegisterMesaRoute({List<_i29.PageRouteInfo>? children})
      : super(
          RegisterMesaRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterMesaRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return _i21.RegisterMesaPage();
    },
  );
}

/// generated route for
/// [_i22.RegisterPage]
class RegisterRoute extends _i29.PageRouteInfo<RegisterRouteArgs> {
  RegisterRoute({
    _i30.Key? key,
    required dynamic Function(bool) onResult,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          RegisterRoute.name,
          args: RegisterRouteArgs(
            key: key,
            onResult: onResult,
          ),
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RegisterRouteArgs>();
      return _i22.RegisterPage(
        key: args.key,
        onResult: args.onResult,
      );
    },
  );
}

class RegisterRouteArgs {
  const RegisterRouteArgs({
    this.key,
    required this.onResult,
  });

  final _i30.Key? key;

  final dynamic Function(bool) onResult;

  @override
  String toString() {
    return 'RegisterRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i23.SplashPage]
class SplashRoute extends _i29.PageRouteInfo<void> {
  const SplashRoute({List<_i29.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i23.SplashPage();
    },
  );
}

/// generated route for
/// [_i24.SurveyResultsPage]
class SurveyResultsRoute extends _i29.PageRouteInfo<SurveyResultsRouteArgs> {
  SurveyResultsRoute({
    _i30.Key? key,
    required int mesaNumero,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          SurveyResultsRoute.name,
          args: SurveyResultsRouteArgs(
            key: key,
            mesaNumero: mesaNumero,
          ),
          initialChildren: children,
        );

  static const String name = 'SurveyResultsRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SurveyResultsRouteArgs>();
      return _i24.SurveyResultsPage(
        key: args.key,
        mesaNumero: args.mesaNumero,
      );
    },
  );
}

class SurveyResultsRouteArgs {
  const SurveyResultsRouteArgs({
    this.key,
    required this.mesaNumero,
  });

  final _i30.Key? key;

  final int mesaNumero;

  @override
  String toString() {
    return 'SurveyResultsRouteArgs{key: $key, mesaNumero: $mesaNumero}';
  }
}

/// generated route for
/// [_i25.SurveyScreenRoute]
class SurveyRouteRoute extends _i29.PageRouteInfo<SurveyRouteRouteArgs> {
  SurveyRouteRoute({
    _i30.Key? key,
    required _i31.Pedido pedido,
    required double discount,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          SurveyRouteRoute.name,
          args: SurveyRouteRouteArgs(
            key: key,
            pedido: pedido,
            discount: discount,
          ),
          initialChildren: children,
        );

  static const String name = 'SurveyRouteRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SurveyRouteRouteArgs>();
      return _i25.SurveyScreenRoute(
        key: args.key,
        pedido: args.pedido,
        discount: args.discount,
      );
    },
  );
}

class SurveyRouteRouteArgs {
  const SurveyRouteRouteArgs({
    this.key,
    required this.pedido,
    required this.discount,
  });

  final _i30.Key? key;

  final _i31.Pedido pedido;

  final double discount;

  @override
  String toString() {
    return 'SurveyRouteRouteArgs{key: $key, pedido: $pedido, discount: $discount}';
  }
}

/// generated route for
/// [_i26.TappingGameRoute]
class TappingGameRoute extends _i29.PageRouteInfo<TappingGameRouteArgs> {
  TappingGameRoute({
    _i30.Key? key,
    required double difficulty,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          TappingGameRoute.name,
          args: TappingGameRouteArgs(
            key: key,
            difficulty: difficulty,
          ),
          initialChildren: children,
        );

  static const String name = 'TappingGameRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TappingGameRouteArgs>();
      return _i26.TappingGameRoute(
        key: args.key,
        difficulty: args.difficulty,
      );
    },
  );
}

class TappingGameRouteArgs {
  const TappingGameRouteArgs({
    this.key,
    required this.difficulty,
  });

  final _i30.Key? key;

  final double difficulty;

  @override
  String toString() {
    return 'TappingGameRouteArgs{key: $key, difficulty: $difficulty}';
  }
}

/// generated route for
/// [_i27.WaiterQueriesPage]
class WaiterQueriesRoute extends _i29.PageRouteInfo<void> {
  const WaiterQueriesRoute({List<_i29.PageRouteInfo>? children})
      : super(
          WaiterQueriesRoute.name,
          initialChildren: children,
        );

  static const String name = 'WaiterQueriesRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      return const _i27.WaiterQueriesPage();
    },
  );
}

/// generated route for
/// [_i28.WaitingToBeAssignedPage]
class WaitingToBeAssignedRoute
    extends _i29.PageRouteInfo<WaitingToBeAssignedRouteArgs> {
  WaitingToBeAssignedRoute({
    _i30.Key? key,
    required _i31.Pedido pedido,
    List<_i29.PageRouteInfo>? children,
  }) : super(
          WaitingToBeAssignedRoute.name,
          args: WaitingToBeAssignedRouteArgs(
            key: key,
            pedido: pedido,
          ),
          initialChildren: children,
        );

  static const String name = 'WaitingToBeAssignedRoute';

  static _i29.PageInfo page = _i29.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WaitingToBeAssignedRouteArgs>();
      return _i28.WaitingToBeAssignedPage(
        key: args.key,
        pedido: args.pedido,
      );
    },
  );
}

class WaitingToBeAssignedRouteArgs {
  const WaitingToBeAssignedRouteArgs({
    this.key,
    required this.pedido,
  });

  final _i30.Key? key;

  final _i31.Pedido pedido;

  @override
  String toString() {
    return 'WaitingToBeAssignedRouteArgs{key: $key, pedido: $pedido}';
  }
}
