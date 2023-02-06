import 'package:flutter/material.dart';
import 'package:flutter_pocketbase/components/chat_buble.dart';
import 'package:flutter_pocketbase/components/loading_screen.dart';
import 'package:flutter_pocketbase/providers/auth_provider.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_pocketbase/utils/chat_json.dart';
import 'package:flutter_pocketbase/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:badges/badges.dart' as badges;

class SettingEditScreen extends ConsumerWidget {
  const SettingEditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const GetAppBar(),
        Expanded(flex: 1, child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            color: bgColor
          ),
          child:  SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10,),
                const GetImageSetting(),

                const SizedBox(height: 10,),
                InkWell(
                  onTap: () async {
                    LoadingScreen.instance().show(context: context);
                    await ref.read(authProvider.notifier).logOut();
                    LoadingScreen.instance().hide();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(color: textfieldColor, borderRadius: BorderRadius.circular(4)),
                    alignment: Alignment.center,
                    child: const Text("Logout", style: TextStyle(
                      color: Colors.red
                    ),)
                  ),
                )
              ],
            ),
          ),
        )),
      ],
    );
  }
}

class GetAppBar extends ConsumerWidget {
  const GetAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        elevation: 0,
        backgroundColor: greyColor,
        centerTitle: true,
        leading: TextButton(
          onPressed: () => context.go('/settings'),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text("Cancel", style: TextStyle(
              fontSize: 16, color: primary
            ),),
          ),
        ),
        leadingWidth: 200,
        actions: const [
          TextButton(onPressed: null, child: Text("Done", style: TextStyle(
            fontSize: 16, color: primary, fontWeight: FontWeight.w500,
          ), softWrap: false,)),
        
        ],
      ),
    );
  }
}

class GetImageSetting extends ConsumerWidget {
  const GetImageSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: greyColor
            ),
            child: const Center(
              child: Icon(Icons.camera_alt_outlined, color: primary, size: 30,),
            ),
          ),
        ),
        const SizedBox(height: 10,),
        const Text("Set New Photo", style: const TextStyle(
          fontSize: 16, color: primary, fontWeight: FontWeight.w600
        ),),
      ],
    );
  }
}