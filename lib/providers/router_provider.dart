import 'package:flutter/material.dart';
import 'package:flutter_pocketbase/models/auth_model.dart';
import 'package:flutter_pocketbase/pages/home_screen.dart';
import 'package:flutter_pocketbase/pages/learn/learn2.dart';
import 'package:flutter_pocketbase/pages/learn/learn3.dart';
import 'package:flutter_pocketbase/pages/learn/learn5.dart';
import 'package:flutter_pocketbase/pages/learn/leran4.dart';
import 'package:flutter_pocketbase/pages/login_screen.dart';
import 'package:flutter_pocketbase/providers/auth_provider.dart';
import 'package:flutter_pocketbase/providers/login_provider.dart';
import 'package:flutter_pocketbase/providers/states/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AuthModel>(auth_provider, 
    (_, __) => notifyListeners());
    // _ref.watch(login_provider);
  }

  String? _redirect_login(_, GoRouterState state) {
    final auth_state = _ref.read(auth_provider).authSate;

    final are_we_loggin_in = state.location == "/login";

    if (auth_state != AuthSate.success) {
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
    ),
    GoRoute(
      name: 'learn2',
      path: '/learn2',
      builder: (context, state) => const Learn2Screen(),
    ),
    GoRoute(
      name: 'learn3',
      path: '/learn3',
      builder: (context, state) => const Learn3Screen(),
    ),
    GoRoute(
      name: 'learn4',
      path: '/learn4',
      builder: (context, state) => const Learn4Screen(),
    ),
    GoRoute(
      name: 'learn5',
      path: '/learn5',
      builder: (context, state) => const Learn5Screen(),
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