import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_pocketbase/providers/router_provider.dart';
import 'package:flutter_pocketbase/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:badges/badges.dart' as badges;

class MainBottomNavBar extends ConsumerWidget {
  const MainBottomNavBar({super.key});

  static const menu = <Map>[
    {
      "icon": MaterialIcons.account_circle,
      "path": "/contacts",
      "text": "Contacts"
    },
    {
      "icon": Ionicons.ios_chatboxes,
      "path": "/",
      "text": "Chats"
    },
    {
      "icon": MaterialIcons.settings,
      "path": "/settings",
      "text": "Settings"
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(routerProvider).location;
    return Container(
      height: 90,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: greyColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for(var i = 0; i < menu.length; i++)...[
            InkWell(
              onTap: () => context.go(menu[i]['path']),
              child: Column(
                children: [
                  i == 1
                  ? badges.Badge(
                    badgeContent: Text("3", style: TextStyle(color: white),),
                    child: Icon(
                      menu[i]['icon'],
                      size: 30,
                      color: location == menu[i]['path'] ? primary : white.withOpacity(0.5)
                    ),
                  )
                  : Icon(
                    menu[i]['icon'],
                    size: 30,
                    color: location == menu[i]['path'] ? primary : white.withOpacity(0.5),
                  ),
                  const SizedBox(height: 3,),
                  Text(
                    menu[i]['text'],
                    style: TextStyle(
                      fontSize: 11, 
                      color: location == menu[i]['path'] ? primary : white.withOpacity(0.5)
                    ),
                  )
                ],
              )
            )
          ],
        ],
      ),
    );
  }
}