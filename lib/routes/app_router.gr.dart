// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i19;
import 'package:flutter/material.dart' as _i20;
import 'package:mondongo/models/mesa.dart' as _i21;
import 'package:mondongo/view/screens/aprobacionClientes.dart' as _i1;
import 'package:mondongo/view/screens/customer_query_page.dart' as _i3;
import 'package:mondongo/view/screens/home.dart' as _i4;
import 'package:mondongo/view/screens/login.dart' as _i5;
import 'package:mondongo/view/screens/mesa_page.dart' as _i6;
import 'package:mondongo/view/screens/mesa_qr_scanner_page.dart' as _i7;
import 'package:mondongo/view/screens/PedidosListPage.dart' as _i8;
import 'package:mondongo/view/screens/products_list_page.dart' as _i9;
import 'package:mondongo/view/screens/qr_scan_page.dart' as _i10;
import 'package:mondongo/view/screens/reate_product_page.dart' as _i2;
import 'package:mondongo/view/screens/register.dart' as _i15;
import 'package:mondongo/view/screens/register_cliente.dart' as _i11;
import 'package:mondongo/view/screens/register_dueno_supervisor.dart' as _i12;
import 'package:mondongo/view/screens/register_empleado.dart' as _i13;
import 'package:mondongo/view/screens/register_mesa.dart' as _i14;
import 'package:mondongo/view/screens/splash.dart' as _i16;
import 'package:mondongo/view/screens/waiter_queries_page.dart' as _i17;
import 'package:mondongo/view/screens/waiting_to_be_assigned_page.dart' as _i18;

/// generated route for
/// [_i1.AprobacionClientesPage]
class AprobacionClientesRoute extends _i19.PageRouteInfo<void> {
  const AprobacionClientesRoute({List<_i19.PageRouteInfo>? children})
      : super(
          AprobacionClientesRoute.name,
          initialChildren: children,
        );

  static const String name = 'AprobacionClientesRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i1.AprobacionClientesPage();
    },
  );
}

/// generated route for
/// [_i2.CreateProductPage]
class CreateProductRoute extends _i19.PageRouteInfo<void> {
  const CreateProductRoute({List<_i19.PageRouteInfo>? children})
      : super(
          CreateProductRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateProductRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i2.CreateProductPage();
    },
  );
}

/// generated route for
/// [_i3.CustomerQueryPage]
class CustomerQueryRoute extends _i19.PageRouteInfo<void> {
  const CustomerQueryRoute({List<_i19.PageRouteInfo>? children})
      : super(
          CustomerQueryRoute.name,
          initialChildren: children,
        );

  static const String name = 'CustomerQueryRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i3.CustomerQueryPage();
    },
  );
}

/// generated route for
/// [_i4.HomePage]
class HomeRoute extends _i19.PageRouteInfo<void> {
  const HomeRoute({List<_i19.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i4.HomePage();
    },
  );
}

/// generated route for
/// [_i5.LoginPage]
class LoginRoute extends _i19.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i20.Key? key,
    required dynamic Function(bool) onResult,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onResult: onResult,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>();
      return _i5.LoginPage(
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

  final _i20.Key? key;

  final dynamic Function(bool) onResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i6.MesaPage]
class MesaRoute extends _i19.PageRouteInfo<MesaRouteArgs> {
  MesaRoute({
    _i20.Key? key,
    required _i21.Mesa mesa,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          MesaRoute.name,
          args: MesaRouteArgs(
            key: key,
            mesa: mesa,
          ),
          initialChildren: children,
        );

  static const String name = 'MesaRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MesaRouteArgs>();
      return _i6.MesaPage(
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

  final _i20.Key? key;

  final _i21.Mesa mesa;

  @override
  String toString() {
    return 'MesaRouteArgs{key: $key, mesa: $mesa}';
  }
}

/// generated route for
/// [_i7.MesaQrScannerPage]
class MesaQrScannerRoute extends _i19.PageRouteInfo<void> {
  const MesaQrScannerRoute({List<_i19.PageRouteInfo>? children})
      : super(
          MesaQrScannerRoute.name,
          initialChildren: children,
        );

  static const String name = 'MesaQrScannerRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i7.MesaQrScannerPage();
    },
  );
}

/// generated route for
/// [_i8.PedidosListPage]
class PedidosListRoute extends _i19.PageRouteInfo<void> {
  const PedidosListRoute({List<_i19.PageRouteInfo>? children})
      : super(
          PedidosListRoute.name,
          initialChildren: children,
        );

  static const String name = 'PedidosListRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return _i8.PedidosListPage();
    },
  );
}

/// generated route for
/// [_i9.ProductsListPage]
class ProductsListRoute extends _i19.PageRouteInfo<void> {
  const ProductsListRoute({List<_i19.PageRouteInfo>? children})
      : super(
          ProductsListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductsListRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i9.ProductsListPage();
    },
  );
}

/// generated route for
/// [_i10.QrScannerPage]
class QrScannerRoute extends _i19.PageRouteInfo<void> {
  const QrScannerRoute({List<_i19.PageRouteInfo>? children})
      : super(
          QrScannerRoute.name,
          initialChildren: children,
        );

  static const String name = 'QrScannerRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return _i10.QrScannerPage();
    },
  );
}

/// generated route for
/// [_i11.RegisterClientePage]
class RegisterClienteRoute extends _i19.PageRouteInfo<void> {
  const RegisterClienteRoute({List<_i19.PageRouteInfo>? children})
      : super(
          RegisterClienteRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterClienteRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i11.RegisterClientePage();
    },
  );
}

/// generated route for
/// [_i12.RegisterDuenoSupervisorPage]
class RegisterDuenoSupervisorRoute extends _i19.PageRouteInfo<void> {
  const RegisterDuenoSupervisorRoute({List<_i19.PageRouteInfo>? children})
      : super(
          RegisterDuenoSupervisorRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterDuenoSupervisorRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return _i12.RegisterDuenoSupervisorPage();
    },
  );
}

/// generated route for
/// [_i13.RegisterEmpleadoPage]
class RegisterEmpleadoRoute extends _i19.PageRouteInfo<void> {
  const RegisterEmpleadoRoute({List<_i19.PageRouteInfo>? children})
      : super(
          RegisterEmpleadoRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterEmpleadoRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return _i13.RegisterEmpleadoPage();
    },
  );
}

/// generated route for
/// [_i14.RegisterMesaPage]
class RegisterMesaRoute extends _i19.PageRouteInfo<void> {
  const RegisterMesaRoute({List<_i19.PageRouteInfo>? children})
      : super(
          RegisterMesaRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterMesaRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return _i14.RegisterMesaPage();
    },
  );
}

/// generated route for
/// [_i15.RegisterPage]
class RegisterRoute extends _i19.PageRouteInfo<RegisterRouteArgs> {
  RegisterRoute({
    _i20.Key? key,
    required dynamic Function(bool) onResult,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          RegisterRoute.name,
          args: RegisterRouteArgs(
            key: key,
            onResult: onResult,
          ),
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RegisterRouteArgs>();
      return _i15.RegisterPage(
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

  final _i20.Key? key;

  final dynamic Function(bool) onResult;

  @override
  String toString() {
    return 'RegisterRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i16.SplashPage]
class SplashRoute extends _i19.PageRouteInfo<void> {
  const SplashRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i16.SplashPage();
    },
  );
}

/// generated route for
/// [_i17.WaiterQueriesPage]
class WaiterQueriesRoute extends _i19.PageRouteInfo<void> {
  const WaiterQueriesRoute({List<_i19.PageRouteInfo>? children})
      : super(
          WaiterQueriesRoute.name,
          initialChildren: children,
        );

  static const String name = 'WaiterQueriesRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i17.WaiterQueriesPage();
    },
  );
}

/// generated route for
/// [_i18.WaitingToBeAssignedPage]
class WaitingToBeAssignedRoute extends _i19.PageRouteInfo<void> {
  const WaitingToBeAssignedRoute({List<_i19.PageRouteInfo>? children})
      : super(
          WaitingToBeAssignedRoute.name,
          initialChildren: children,
        );

  static const String name = 'WaitingToBeAssignedRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i18.WaitingToBeAssignedPage();
    },
  );
}
