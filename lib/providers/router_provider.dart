import 'package:flutter/material.dart';
import 'package:flutter_pocketbase/components/page_transition.dart';
import 'package:flutter_pocketbase/layouts/main_layout.dart';
import 'package:flutter_pocketbase/models/auth_model.dart';
import 'package:flutter_pocketbase/pages/chat_detail.dart';
import 'package:flutter_pocketbase/pages/contacts_screen.dart';
import 'package:flutter_pocketbase/pages/chat_screen.dart';
import 'package:flutter_pocketbase/pages/first_load_screen.dart';
import 'package:flutter_pocketbase/pages/login_screen.dart';
import 'package:flutter_pocketbase/pages/settings/setting_edit_screen.dart';
import 'package:flutter_pocketbase/pages/settings_screen.dart';
import 'package:flutter_pocketbase/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(authProvider, 
    (_, __) => notifyListeners());
    // _ref.watch(login_provider);
  }

  String? _redirect_login(_, GoRouterState state) {
    final authSate = _ref.read(authProvider).authSate;
    
    if (authSate == AuthSate.initial) return null;

    final are_we_loggin_in = state.location == "/login";

    if (authSate != AuthSate.login) {
      if (state.location == '/loading') {

      }
      return are_we_loggin_in ? null : '/login';
    }

    if (are_we_loggin_in || state.location == '/loading') return '/';

    return null;    
  }

  List<RouteBase> get _routers => [
    ShellRoute(
      // navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          name: 'chat',
          path: '/',
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context, 
            state: state, 
            child: const ChatScreen(),
          ),
          routes: [
            GoRoute(
              name: 'chat-detail',
              path: 'chat-detail/:userId',
              pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context, 
                state: state, 
                child: ChatDetailScreen(id: state.params['userId']),
              ),
            ),
          ]
        ),
        GoRoute(
          name: 'contacts',
          path: '/contacts',
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context, 
            state: state, 
            child: const ContactsScreen(),
          ),
        ),
        GoRoute(
          name: 'settings',
          path: '/settings',
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context, 
            state: state, 
            child: const SettingsScreen(),
          ),
          routes: [
            GoRoute(
              name: 'setting-edit',
              path: 'edit',
              pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context, 
                state: state, 
                child: SettingEditScreen(),
              ),
            ),
          ]
        ),
      ]
    ),
    
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      name: 'loading',
      path: '/loading',
      builder: (context, state) => const FirstLoadScreen(),
    ),
  ];
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/loading',
    debugLogDiagnostics: true,
    refreshListenable: router,
    redirect: router._redirect_login,
    routes: router._routers
  );
});