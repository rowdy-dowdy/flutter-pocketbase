import 'package:flutter/material.dart';
import 'package:flutter_pocketbase/page/home_screen.dart';
import 'package:flutter_pocketbase/page/learn/learn2.dart';
import 'package:flutter_pocketbase/page/learn/learn3.dart';
import 'package:flutter_pocketbase/page/login_screen.dart';
import 'package:flutter_pocketbase/provider/login_provider.dart';
import 'package:flutter_pocketbase/provider/state/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<LoginState>(login_provider, 
    (_, __) => notifyListeners());
    // _ref.watch(login_provider);
  }

  String? _redirect_login(_, GoRouterState state) {
    final login_state = _ref.read(login_provider);
    print(login_state);

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
    )
  ];
}

final router_provider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/learn3',
    debugLogDiagnostics: true,
    refreshListenable: router,
    // redirect: router._redirect_login,
    routes: router._routers
  );
});