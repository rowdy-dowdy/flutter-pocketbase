import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainBottomNavBar extends ConsumerWidget {
  const MainBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color.fromARGB(255, 221, 221, 221)),
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () => context.go('/'),
            child: const Icon(
              Icons.dashboard,
              size: 24,
              color: Colors.blue,
            )
          ),
          InkWell(
            onTap: () => context.go('/calendar'),
            child: const Icon(
              Icons.calendar_month_outlined,
              size: 24,
              color: Colors.blue,
            )
          ),
          InkWell(
            onTap: () => context.go('/news'),
            child: const Icon(
              Icons.newspaper,
              size: 24,
              color: Colors.blue,
            )
          ),
          InkWell(
            onTap: () => context.go('/notifications'),
            child: const Icon(
              Icons.notifications,
              size: 24,
              color: Colors.blue,
            )
          ),
          InkWell(
            onTap: () => context.go('/user'),
            child: const Icon(
              Icons.person,
              size: 24,
              color: Colors.blue,
            )
          )
        ],
      ),
    );
  }
}