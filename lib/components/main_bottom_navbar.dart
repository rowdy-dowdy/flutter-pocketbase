import 'package:flutter/material.dart';
import 'package:flutter_pocketbase/providers/router_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainBottomNavBar extends ConsumerWidget {
  const MainBottomNavBar({super.key});

  static const menu = <Map>[
    {
      "icon": Icons.dashboard,
      "path": "/"
    },
    {
      "icon": Icons.calendar_month_outlined,
      "path": "/calendar"
    },
    {
      "icon": Icons.newspaper,
      "path": "/news"
    },
    {
      "icon": Icons.notifications,
      "path": "/notifications"
    },
    {
      "icon": Icons.person,
      "path": "/user"
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(routerProvider).location;
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
          for(var i = 0; i < menu.length; i++)...[
            InkWell(
              onTap: () => context.go(menu[i]['path']),
              child: Icon(
                menu[i]['icon'],
                size: 24,
                color: location == menu[i]['path'] ? Colors.blue : null,
              )
            )
          ],
        ],
      ),
    );
  }
}