import 'package:flutter/material.dart';
import 'package:flutter_pocketbase/components/chat_buble.dart';
import 'package:flutter_pocketbase/models/message_model.dart';
import 'package:flutter_pocketbase/providers/auth_provider.dart';
import 'package:flutter_pocketbase/repositories/chat_repository.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_pocketbase/utils/chat_json.dart';
import 'package:flutter_pocketbase/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:badges/badges.dart' as badges;
import 'package:intl/intl.dart';

final messagesProvider = FutureProvider.family<ListMessageModel?, String?>((ref, roomId) async {
  return await ref.read(MessageRepositoryProvider).fetchData(roomId);
});

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
          height: double.infinity,
          decoration: const BoxDecoration(
            color: bgColor
          ),
          child: GetBodyChat(roomId: id,)
        )),
        const GetBottomBar(),
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
      // height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: const BoxDecoration(
        color: greyColor
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.attachment, color: primary, size: 25,),
          const SizedBox(width: 5,),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30)
              ),
              child: Row(
                children: const [
                  Flexible(
                    child: TextField(
                      style: TextStyle(
                        color: white
                      ),
                      cursorColor: primary,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Icon(Icons.emoji_emotions_rounded, color: primary, size: 25,)
                ],
              ),
            ),
          ),
          const SizedBox(width: 5,),
          const Icon(Icons.mic, color: primary, size: 25,)
        ],
      ),
    );
  }
}

class GetBodyChat extends ConsumerWidget {
  final String? roomId;
  const GetBodyChat({required this.roomId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMessage = ref.watch(messagesProvider(roomId));
    ref.refresh(messagesProvider(roomId));
    return currentMessage.when(
      data: (data) {
        print(data!.messages);
        if (data != null && data.messages.isNotEmpty) {
          final userLogin = ref.watch(authProvider).user;
          String senderId = "";
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            children: List.generate(data.messages.length, (index) {
              bool isLast = senderId != data.messages[index].senderID;
              senderId = data.messages[index].senderID;

              return CustomBubbleChat(
                isMe: data.messages[index].senderID == userLogin!.id,
                message: data.messages[index].body,
                time: DateFormat('hh:mm a').format(DateTime.parse(data.messages[index].createdAt)),
                isLast: isLast,
              );
            }),
          );
        }
        else {
          return Container(
            child: const Text("No chat", style: TextStyle(color: white),),
          );
        }
      },
      error: (_,__) => const Text('Error 😭'),
      loading: () => const Padding(
        padding: EdgeInsets.all(8),
        child: CircularProgressIndicator(),
      )
    );
  }
}

