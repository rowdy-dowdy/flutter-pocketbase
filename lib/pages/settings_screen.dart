import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_pocketbase/utils/chat_json.dart';
import 'package:flutter_pocketbase/utils/colors.dart';
import 'package:flutter_pocketbase/utils/setting_json.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:badges/badges.dart' as badges;

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const GetAppBar(),
        Expanded(flex: 1, child: Container(
          decoration: const BoxDecoration(
            color: bgColor
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const GetImageSetting(),
                GetSection(setting_section_data: setting_section_one,),
                const SizedBox(height: 30,),
                GetSection(setting_section_data: setting_section_two,),
                const SizedBox(height: 30,),
                GetSection(setting_section_data: setting_section_three,),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ))
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
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.qr_code, color: primary, size: 26,),
        ),
        actions: [
          TextButton(
            onPressed: () => context.go('/settings/edit'), 
            child: const Text("Edit", style: TextStyle(
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: NetworkImage(profile[0]['img']), fit: BoxFit.cover)
            ),
          ),
        ),
        const SizedBox(height: 20,),
        Text(profile[0]['name'], style: const TextStyle(
          fontSize: 24, color: white, fontWeight: FontWeight.w600
        ),),
        const SizedBox(height: 2,),
        Text("+84 399 633 237 - @viethungit", style: TextStyle(
          fontSize: 18, color: white.withOpacity(0.5), fontWeight: FontWeight.w500
        ),),
        const SizedBox(height: 20,)
      ],
    );
  }
}

class GetSection extends ConsumerWidget {
  final setting_section_data;
  const GetSection({required this.setting_section_data, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        for(var i = 0; i < setting_section_data.length; i++)...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: textfieldColor
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: setting_section_data[i]['color'],
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Center(
                    child: Icon(setting_section_data[i]['icon'], color: white, size: 20,),
                  ),
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: Text(setting_section_data[i]['text'], style: const TextStyle(
                    fontSize: 16, color: white, fontWeight: FontWeight.w500
                  ),),
                ),
                const SizedBox(width: 12,),
                GetLangAndSticker(value: setting_section_data[i]['text'],),
                const SizedBox(width: 5,),
                Icon(Icons.arrow_forward_ios, color: white.withOpacity(0.2), size: 15,)
              ],
            ),
          ),
          // const SizedBox(height: 10,)
        ]
      ]
    );
  }

}

class GetLangAndSticker extends ConsumerWidget {
  final value;
  const GetLangAndSticker({required this.value, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (value == "Language") {
      return Text("English", style: TextStyle(
        fontSize: 15, color: white.withOpacity(0.5)
      ),);
    }
    else if (value == "Stickers and Emoji") {
      return const badges.Badge(
        badgeStyle: badges.BadgeStyle(
          badgeColor: primary,
        ),
        badgeContent: Text("12", style: TextStyle(
          fontSize: 15, color: white
        ),),
      );
    }
    else {
      return Container();
    }
  }
}


