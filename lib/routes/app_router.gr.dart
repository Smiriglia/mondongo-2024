// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:mondongo/view/screens/home.dart' as _i1;
import 'package:mondongo/view/screens/login.dart' as _i2;
import 'package:mondongo/view/screens/register.dart' as _i7;
import 'package:mondongo/view/screens/register_cliente.dart' as _i3;
import 'package:mondongo/view/screens/register_dueno_supervisor.dart' as _i4;
import 'package:mondongo/view/screens/register_empleado.dart' as _i5;
import 'package:mondongo/view/screens/register_mesa.dart' as _i6;
import 'package:mondongo/view/screens/splash.dart' as _i8;

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute({List<_i9.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomePage();
    },
  );
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i9.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i10.Key? key,
    required dynamic Function(bool) onResult,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onResult: onResult,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>();
      return _i2.LoginPage(
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

  final _i10.Key? key;

  final dynamic Function(bool) onResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i3.RegisterClientePage]
class RegisterClienteRoute extends _i9.PageRouteInfo<void> {
  const RegisterClienteRoute({List<_i9.PageRouteInfo>? children})
      : super(
          RegisterClienteRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterClienteRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i3.RegisterClientePage();
    },
  );
}

/// generated route for
/// [_i4.RegisterDuenoSupervisorPage]
class RegisterDuenoSupervisorRoute extends _i9.PageRouteInfo<void> {
  const RegisterDuenoSupervisorRoute({List<_i9.PageRouteInfo>? children})
      : super(
          RegisterDuenoSupervisorRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterDuenoSupervisorRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return _i4.RegisterDuenoSupervisorPage();
    },
  );
}

/// generated route for
/// [_i5.RegisterEmpleadoPage]
class RegisterEmpleadoRoute extends _i9.PageRouteInfo<void> {
  const RegisterEmpleadoRoute({List<_i9.PageRouteInfo>? children})
      : super(
          RegisterEmpleadoRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterEmpleadoRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return _i5.RegisterEmpleadoPage();
    },
  );
}

/// generated route for
/// [_i6.RegisterMesaPage]
class RegisterMesaRoute extends _i9.PageRouteInfo<void> {
  const RegisterMesaRoute({List<_i9.PageRouteInfo>? children})
      : super(
          RegisterMesaRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterMesaRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return _i6.RegisterMesaPage();
    },
  );
}

/// generated route for
/// [_i7.RegisterPage]
class RegisterRoute extends _i9.PageRouteInfo<RegisterRouteArgs> {
  RegisterRoute({
    _i10.Key? key,
    required dynamic Function(bool) onResult,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          RegisterRoute.name,
          args: RegisterRouteArgs(
            key: key,
            onResult: onResult,
          ),
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RegisterRouteArgs>();
      return _i7.RegisterPage(
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

  final _i10.Key? key;

  final dynamic Function(bool) onResult;

  @override
  String toString() {
    return 'RegisterRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [_i8.SplashPage]
class SplashRoute extends _i9.PageRouteInfo<void> {
  const SplashRoute({List<_i9.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i8.SplashPage();
    },
  );
}
