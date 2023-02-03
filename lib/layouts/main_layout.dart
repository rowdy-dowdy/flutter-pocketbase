import 'package:flutter/material.dart';
import 'package:flutter_pocketbase/components/main_bottom_navbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;
  const MainLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: child,
            ),
            const MainBottomNavBar()
          ],
        ),
      ),
    );
  }
}