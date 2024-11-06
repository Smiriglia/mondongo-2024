// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:mondongo/models/mesa.dart' as _i14;
import 'package:mondongo/view/screens/aprobacionClientes.dart' as _i1;
import 'package:mondongo/view/screens/home.dart' as _i2;
import 'package:mondongo/view/screens/login.dart' as _i3;
import 'package:mondongo/view/screens/mesa_page.dart' as _i4;
import 'package:mondongo/view/screens/qr_scan_page.dart' as _i5;
import 'package:mondongo/view/screens/register.dart' as _i10;
import 'package:mondongo/view/screens/register_cliente.dart' as _i6;
import 'package:mondongo/view/screens/register_dueno_supervisor.dart' as _i7;
import 'package:mondongo/view/screens/register_empleado.dart' as _i8;
import 'package:mondongo/view/screens/register_mesa.dart' as _i9;
import 'package:mondongo/view/screens/splash.dart' as _i11;

/// generated route for
/// [_i1.AprobacionClientesPage]
class AprobacionClientesRoute extends _i12.PageRouteInfo<void> {
  const AprobacionClientesRoute({List<_i12.PageRouteInfo>? children})
      : super(
          AprobacionClientesRoute.name,
          initialChildren: children,
        );

  static const String name = 'AprobacionClientesRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i1.AprobacionClientesPage();
    },
  );
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i12.PageRouteInfo<void> {
  const HomeRoute({List<_i12.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.LoginPage]
class LoginRoute extends _i12.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i13.Key? key,
    required dynamic Function(bool) onResult,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onResult: onResult,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i12.PageInfo page = _i12.PageInfo(
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

  final _i13.Key? key;

  final dynamic Function(bool) onResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i4.MesaPage]
class MesaRoute extends _i12.PageRouteInfo<MesaRouteArgs> {
  MesaRoute({
    _i13.Key? key,
    required _i14.Mesa mesa,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          MesaRoute.name,
          args: MesaRouteArgs(
            key: key,
            mesa: mesa,
          ),
          initialChildren: children,
        );

  static const String name = 'MesaRoute';

  static _i12.PageInfo page = _i12.PageInfo(
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

  final _i13.Key? key;

  final _i14.Mesa mesa;

  @override
  String toString() {
    return 'MesaRouteArgs{key: $key, mesa: $mesa}';
  }
}

/// generated route for
/// [_i5.QrScannerPage]
class QrScannerRoute extends _i12.PageRouteInfo<void> {
  const QrScannerRoute({List<_i12.PageRouteInfo>? children})
      : super(
          QrScannerRoute.name,
          initialChildren: children,
        );

  static const String name = 'QrScannerRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return _i5.QrScannerPage();
    },
  );
}

/// generated route for
/// [_i6.RegisterClientePage]
class RegisterClienteRoute extends _i12.PageRouteInfo<void> {
  const RegisterClienteRoute({List<_i12.PageRouteInfo>? children})
      : super(
          RegisterClienteRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterClienteRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i6.RegisterClientePage();
    },
  );
}

/// generated route for
/// [_i7.RegisterDuenoSupervisorPage]
class RegisterDuenoSupervisorRoute extends _i12.PageRouteInfo<void> {
  const RegisterDuenoSupervisorRoute({List<_i12.PageRouteInfo>? children})
      : super(
          RegisterDuenoSupervisorRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterDuenoSupervisorRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return _i7.RegisterDuenoSupervisorPage();
    },
  );
}

/// generated route for
/// [_i8.RegisterEmpleadoPage]
class RegisterEmpleadoRoute extends _i12.PageRouteInfo<void> {
  const RegisterEmpleadoRoute({List<_i12.PageRouteInfo>? children})
      : super(
          RegisterEmpleadoRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterEmpleadoRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return _i8.RegisterEmpleadoPage();
    },
  );
}

/// generated route for
/// [_i9.RegisterMesaPage]
class RegisterMesaRoute extends _i12.PageRouteInfo<void> {
  const RegisterMesaRoute({List<_i12.PageRouteInfo>? children})
      : super(
          RegisterMesaRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterMesaRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return _i9.RegisterMesaPage();
    },
  );
}

/// generated route for
/// [_i10.RegisterPage]
class RegisterRoute extends _i12.PageRouteInfo<RegisterRouteArgs> {
  RegisterRoute({
    _i13.Key? key,
    required dynamic Function(bool) onResult,
    List<_i12.PageRouteInfo>? children,
  }) : super(
          RegisterRoute.name,
          args: RegisterRouteArgs(
            key: key,
            onResult: onResult,
          ),
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RegisterRouteArgs>();
      return _i10.RegisterPage(
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

  final _i13.Key? key;

  final dynamic Function(bool) onResult;

  @override
  String toString() {
    return 'RegisterRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i11.SplashPage]
class SplashRoute extends _i12.PageRouteInfo<void> {
  const SplashRoute({List<_i12.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i11.SplashPage();
    },
  );
}
