import 'package:flutter/material.dart';
import 'package:flutter_pocketbase/page/home_screen.dart';
import 'package:flutter_pocketbase/page/login_screen.dart';
import 'package:flutter_pocketbase/provider/router_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(router_provider);

    return MaterialApp.router(
      title: 'Auth Riverpod GoRouter',
      // theme: ThemeData(
      //   primarySwatch: Colors.deepOrange,
      // ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      // routeInformationParser: router.routeInformationParser,
      // routerDelegate: router.routerDelegate,
      routerConfig: router,
    );
  }
}