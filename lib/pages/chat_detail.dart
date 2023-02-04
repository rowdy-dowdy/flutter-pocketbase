import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_pocketbase/utils/chat_json.dart';
import 'package:flutter_pocketbase/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:badges/badges.dart' as badges;

class ChatDetailScreen extends ConsumerWidget {
  final String? id;
  const ChatDetailScreen({required this.id, super.key});

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
              children: const [
                Text("hung", style: TextStyle(color: white),)
              ],
            ),
          ),
        )),
        const GetBottomBar()
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
        title: Container(
          child: Column(
            children: [
              Text("Việt Hùng Ít", style: const TextStyle(
                fontSize: 17, color: white, fontWeight: FontWeight.bold
              ),),
              Text("last seen recently", style: TextStyle(
                fontSize: 12, color: white.withOpacity(0.4)
              ),)
            ],
          ),
        ),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back_ios, color: primary,)
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: NetworkImage("https://avatars.githubusercontent.com/u/33823245?v=4"),
          )
        ],
      ),
    );
  }
}

class GetBottomBar  extends ConsumerWidget {
  const GetBottomBar ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        color: greyColor
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Entypo.attachment, color: primary, size: 21,),
          Container(
            decoration: BoxDecoration(
              color: white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30)
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                style: TextStyle(
                  color: white
                ),
                cursorColor: primary,
                // decoration: InputDecoration(
                //   border: InputBorder.none
                // ),
              ),
            ),
          ),
          const Icon(MaterialCommunityIcons.microphone, color: primary, size: 21,)
        ],
      ),
    );
  }
}

