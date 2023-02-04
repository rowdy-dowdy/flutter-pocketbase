import 'package:flutter/material.dart';
import 'package:flutter_pocketbase/components/main_bottom_navbar.dart';
import 'package:flutter_pocketbase/providers/router_provider.dart';
import 'package:flutter_pocketbase/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;
  const MainLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final routerSplit = router.location.split('/');
    final isChildPage = routerSplit.length > 2;
    
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: child
      ),
      bottomNavigationBar: !isChildPage ? const MainBottomNavBar() : null,
    );
  }
}