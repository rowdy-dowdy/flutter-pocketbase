import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_pocketbase/components/chat_buble.dart';
import 'package:flutter_pocketbase/models/message_model.dart';
import 'package:flutter_pocketbase/models/user_model.dart';
import 'package:flutter_pocketbase/providers/auth_provider.dart';
import 'package:flutter_pocketbase/providers/chat_provider.dart';
import 'package:flutter_pocketbase/repositories/chat_repository.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_pocketbase/utils/chat_json.dart';
import 'package:flutter_pocketbase/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:badges/badges.dart' as badges;
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class ChatDetailScreen extends ConsumerWidget {
  final String? id;
  const ChatDetailScreen({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final liveChat = ref.read(chatProvider(id!).notifier).getRoomData();
    // print(liveChat);
    return Column(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GetAppBar(roomId: id,),
        Expanded(flex: 1, child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            color: bgColor
          ),
          child: GetBodyChat(roomId: id,)
        )),
        GetBottomBar(roomId: id),
      ],
    );
  }
}

class GetAppBar extends ConsumerWidget {
  final String? roomId;
  const GetAppBar({required this.roomId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        elevation: 0,
        backgroundColor: greyColor,
        centerTitle: true,
        title: Container(
          child: Consumer(
            builder: (context, ref, child) {
              final liveChat = ref.watch(chatProvider(roomId!));
              
              final userLogin = ref.watch(authProvider).user;
              UserModel? info = liveChat.users.firstWhereOrNull((v) => v.id != userLogin!.id);

              return Column(
                children: [
                  Text(info?.name ?? "", style: const TextStyle(
                    fontSize: 17, color: white, fontWeight: FontWeight.bold
                  ),),
                  Text("last seen recently", style: TextStyle(
                    fontSize: 12, color: white.withOpacity(0.4)
                  ),)
                ],
              );
            }
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

class GetBottomBar extends ConsumerStatefulWidget {
  final String? roomId;
  const GetBottomBar({required this.roomId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GetBottomBarState();
}

class _GetBottomBarState extends ConsumerState<GetBottomBar> {

  final _textMessageController = TextEditingController();
  String sendIcon = "mic";

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _textMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                children: [
                  Flexible(
                    child: TextField(
                      controller: _textMessageController,
                      onChanged: (text) {
                        if (text == "") {
                          sendIcon = "mic";
                        }
                        else {
                          sendIcon = "send";
                        }
                        setState(() {});
                      },
                      style: const TextStyle(
                        color: white
                      ),
                      cursorColor: primary,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  const Icon(Icons.emoji_emotions_rounded, color: primary, size: 25,)
                ],
              ),
            ),
          ),
          const SizedBox(width: 5,),
          sendIcon == "send"
          ? InkWell(
            onTap: () async {
              await ref.read(chatRepositoryProvider).sendMessage(widget.roomId, _textMessageController.text);
              _textMessageController.text = "";
            },
              child: Icon(Icons.send, color: primary, size: 25,)
            )
          : const Icon(Icons.mic, color: primary, size: 25,)
        ],
      ),
    );
  }
}


class GetBodyChat extends ConsumerStatefulWidget {
  final String? roomId;
  const GetBodyChat({required this.roomId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GetBodyChatState();
}

class _GetBodyChatState extends ConsumerState<GetBodyChat> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final liveChat = ref.watch(chatProvider(widget.roomId!).notifier).state.loading;
    // print(liveChat);
    return Consumer(builder: (context, ref, child) {
      final liveChat = ref.watch(chatProvider(widget.roomId!));

      // print('live chat');
      // print(liveChat.messages);

      if (liveChat.loading) {
        return Container(
          width: 30,
          height: 30,
          padding: const EdgeInsets.all(8),
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      if (liveChat.messages.isEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text('Not Messages'),
        );
      }

      SchedulerBinding.instance.addPostFrameCallback((_) {
        messageController
          .jumpTo(messageController.position.maxScrollExtent);
      });

      final userLogin = ref.watch(authProvider).user;

      final messages = liveChat.messages.reversed.toList();

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        controller: messageController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          bool isLast = index == (messages.length - 1) ? true : message.senderID != messages[index + 1].senderID ? true : false;

          return CustomBubbleChat(
            isMe: message.senderID == userLogin!.id,
            message: message.body,
            time: DateFormat('hh:mm a').format(DateTime.parse(message.createdAt)),
            isLast: isLast,
          );
        }
      );
    });


    final liveChat2 = ref.watch(chatStreamProvider(widget.roomId!));
    return liveChat2.when(
      data: (data) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController
            .jumpTo(messageController.position.maxScrollExtent);
        });

        final userLogin = ref.watch(authProvider).user;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20),
          controller: messageController,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final message = data[index];
            bool isLast = index == (data.length - 1) ? true : message.senderID != data[index + 1].senderID ? true : false;

            return CustomBubbleChat(
              isMe: message.senderID == userLogin!.id,
              message: message.body,
              time: DateFormat('hh:mm a').format(DateTime.parse(message.createdAt)),
              isLast: isLast,
            );
          }
        );
      },
      error: (_,__) => const Text('Error 😭'),
      loading: () => Container(
        width: 30,
        height: 30,
        padding: const EdgeInsets.all(8),
        child: const Center(child: CircularProgressIndicator()),
      )
    );
  }
}