import 'package:flutter/material.dart';
import 'package:flutter_pocketbase/page/home_screen.dart';
import 'package:flutter_pocketbase/page/login_screen.dart';
import 'package:flutter_pocketbase/provider/login_provider.dart';
import 'package:flutter_pocketbase/provider/state/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(login_controller_provider, (previous, next) {
      notifyListeners();
    });
  }

  String? _redirect_login(_, GoRouterState state) {
    final login_state = _ref.read(login_controller_provider);

    final are_we_loggin_in = state.location == "/login";

    if (login_state is LoginStateInitial) {
      return are_we_loggin_in ? null : '/login';
    }

    if (are_we_loggin_in) return '/';

    return null;    
  }

  List<GoRoute> get _routers => [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    )
  ];
}

final router_provider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: router,
    redirect: router._redirect_login,
    routes: router._routers
  );
});