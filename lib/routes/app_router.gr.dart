// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i14;
import 'package:flutter/material.dart' as _i15;
import 'package:mondongo/models/mesa.dart' as _i16;
import 'package:mondongo/view/screens/aprobacionClientes.dart' as _i1;
import 'package:mondongo/view/screens/home.dart' as _i2;
import 'package:mondongo/view/screens/login.dart' as _i3;
import 'package:mondongo/view/screens/mesa_page.dart' as _i4;
import 'package:mondongo/view/screens/PedidosListPage.dart' as _i5;
import 'package:mondongo/view/screens/qr_scan_page.dart' as _i6;
import 'package:mondongo/view/screens/register.dart' as _i11;
import 'package:mondongo/view/screens/register_cliente.dart' as _i7;
import 'package:mondongo/view/screens/register_dueno_supervisor.dart' as _i8;
import 'package:mondongo/view/screens/register_empleado.dart' as _i9;
import 'package:mondongo/view/screens/register_mesa.dart' as _i10;
import 'package:mondongo/view/screens/splash.dart' as _i12;
import 'package:mondongo/view/screens/waiting_to_be_assigned_page.dart' as _i13;

/// generated route for
/// [_i1.AprobacionClientesPage]
class AprobacionClientesRoute extends _i14.PageRouteInfo<void> {
  const AprobacionClientesRoute({List<_i14.PageRouteInfo>? children})
      : super(
          AprobacionClientesRoute.name,
          initialChildren: children,
        );

  static const String name = 'AprobacionClientesRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return const _i1.AprobacionClientesPage();
    },
  );
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i14.PageRouteInfo<void> {
  const HomeRoute({List<_i14.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.LoginPage]
class LoginRoute extends _i14.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i15.Key? key,
    required dynamic Function(bool) onResult,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onResult: onResult,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>();
      return _i3.LoginPage(
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

  final _i15.Key? key;

  final dynamic Function(bool) onResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i4.MesaPage]
class MesaRoute extends _i14.PageRouteInfo<MesaRouteArgs> {
  MesaRoute({
    _i15.Key? key,
    required _i16.Mesa mesa,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          MesaRoute.name,
          args: MesaRouteArgs(
            key: key,
            mesa: mesa,
          ),
          initialChildren: children,
        );

  static const String name = 'MesaRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MesaRouteArgs>();
      return _i4.MesaPage(
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

  final _i15.Key? key;

  final _i16.Mesa mesa;

  @override
  String toString() {
    return 'MesaRouteArgs{key: $key, mesa: $mesa}';
  }
}

/// generated route for
/// [_i5.PedidosListPage]
class PedidosListRoute extends _i14.PageRouteInfo<void> {
  const PedidosListRoute({List<_i14.PageRouteInfo>? children})
      : super(
          PedidosListRoute.name,
          initialChildren: children,
        );

  static const String name = 'PedidosListRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return _i5.PedidosListPage();
    },
  );
}

/// generated route for
/// [_i6.QrScannerPage]
class QrScannerRoute extends _i14.PageRouteInfo<void> {
  const QrScannerRoute({List<_i14.PageRouteInfo>? children})
      : super(
          QrScannerRoute.name,
          initialChildren: children,
        );

  static const String name = 'QrScannerRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return _i6.QrScannerPage();
    },
  );
}

/// generated route for
/// [_i7.RegisterClientePage]
class RegisterClienteRoute extends _i14.PageRouteInfo<void> {
  const RegisterClienteRoute({List<_i14.PageRouteInfo>? children})
      : super(
          RegisterClienteRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterClienteRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return const _i7.RegisterClientePage();
    },
  );
}

/// generated route for
/// [_i8.RegisterDuenoSupervisorPage]
class RegisterDuenoSupervisorRoute extends _i14.PageRouteInfo<void> {
  const RegisterDuenoSupervisorRoute({List<_i14.PageRouteInfo>? children})
      : super(
          RegisterDuenoSupervisorRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterDuenoSupervisorRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return _i8.RegisterDuenoSupervisorPage();
    },
  );
}

/// generated route for
/// [_i9.RegisterEmpleadoPage]
class RegisterEmpleadoRoute extends _i14.PageRouteInfo<void> {
  const RegisterEmpleadoRoute({List<_i14.PageRouteInfo>? children})
      : super(
          RegisterEmpleadoRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterEmpleadoRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return _i9.RegisterEmpleadoPage();
    },
  );
}

/// generated route for
/// [_i10.RegisterMesaPage]
class RegisterMesaRoute extends _i14.PageRouteInfo<void> {
  const RegisterMesaRoute({List<_i14.PageRouteInfo>? children})
      : super(
          RegisterMesaRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterMesaRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return _i10.RegisterMesaPage();
    },
  );
}

/// generated route for
/// [_i11.RegisterPage]
class RegisterRoute extends _i14.PageRouteInfo<RegisterRouteArgs> {
  RegisterRoute({
    _i15.Key? key,
    required dynamic Function(bool) onResult,
    List<_i14.PageRouteInfo>? children,
  }) : super(
          RegisterRoute.name,
          args: RegisterRouteArgs(
            key: key,
            onResult: onResult,
          ),
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RegisterRouteArgs>();
      return _i11.RegisterPage(
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

  final _i15.Key? key;

  final dynamic Function(bool) onResult;

  @override
  String toString() {
    return 'RegisterRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i12.SplashPage]
class SplashRoute extends _i14.PageRouteInfo<void> {
  const SplashRoute({List<_i14.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return const _i12.SplashPage();
    },
  );
}

/// generated route for
/// [_i13.WaitingToBeAssignedPage]
class WaitingToBeAssignedRoute extends _i14.PageRouteInfo<void> {
  const WaitingToBeAssignedRoute({List<_i14.PageRouteInfo>? children})
      : super(
          WaitingToBeAssignedRoute.name,
          initialChildren: children,
        );

  static const String name = 'WaitingToBeAssignedRoute';

  static _i14.PageInfo page = _i14.PageInfo(
    name,
    builder: (data) {
      return _i13.WaitingToBeAssignedPage();
    },
  );
}
