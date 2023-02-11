import 'package:flutter/material.dart';
import 'package:flutter_pocketbase/models/room_model.dart';
import 'package:flutter_pocketbase/models/user_model.dart';
import 'package:flutter_pocketbase/providers/auth_provider.dart';
import 'package:flutter_pocketbase/repositories/room_repository.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_pocketbase/utils/chat_json.dart';
import 'package:flutter_pocketbase/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:badges/badges.dart' as badges;

final roomProvider = FutureProvider<ListRoomModel?>((ref) async {
  return await ref.read(roomRepositoryProvider).fetchRoom();
});

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

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
          child: RefreshIndicator(
            onRefresh: () async {
              ref.refresh(roomProvider.future);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: const [
                  GetSearchBar(),
                  GetListChats()
                ],
              ),
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
        title: const Text("Edit", style: TextStyle(
          fontSize: 16,
          color: white,
          fontWeight: FontWeight.w500
        )),
        leading: IconButton(
          onPressed: () {},
          icon: const Text("Sort",style: TextStyle(
            color: primary,
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),),
        ),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.edit, color: primary,))
        ],
      ),
    );
  }
}

class GetSearchBar extends ConsumerWidget {
  const GetSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      // height: 68,
      decoration: const BoxDecoration(
        color: greyColor
      ),
      child: Container(
        // height: 38,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10)
        ),
        child: TextFormField(
          style: const TextStyle(
            color: white
          ),
          // textAlign: TextAlign.center,
          cursorColor: primary,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: white.withOpacity(0.3),),
            hintText: "Search for message or user",
            hintStyle: TextStyle(
              color: white.withOpacity(0.3),
              fontSize: 17
            )
          ),
        ),
      ),
    );
  }
}

class GetListChats extends ConsumerWidget {
  const GetListChats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRooms = ref.watch(roomProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: currentRooms.when(
        data: (data) {
          final userLogin = ref.watch(authProvider).user;
          if (data?.rooms != null && data!.rooms.isNotEmpty) {
            return Column(
              children: List.generate(data.rooms.length, (index) {

                UserModel user = data.rooms[index].users.where((element) => element.id != userLogin?.id).first;
              
                return GestureDetector(
                  onTap: () => context.go('/chat-detail/${data.rooms[index].id}'),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(user.image,),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      const SizedBox(width: 12,),
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 70,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(user.name, style: const TextStyle(
                                    fontSize: 16,
                                    color: white,
                                    fontWeight: FontWeight.w600
                                  ), maxLines: 2,),
                                  const SizedBox(width: 2,),
                                  Text("3:23 PM", style: TextStyle(
                                    fontSize: 14,
                                    color: white.withOpacity(0.4)
                                  ),)
                                ],
                              ),
                              const SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text("Hey man, lets catup soon", style: TextStyle(
                                      fontSize: 15,
                                      color: white.withOpacity(0.3),), 
                                      maxLines: 1, 
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 2,),
                                  1 > 0
                                  ? badges.Badge(
                                    badgeContent: Text(1.toString(), style: const TextStyle(color: white),),
                                    badgeStyle: const badges.BadgeStyle(
                                      badgeColor: primary
                                    ),
                                  )
                                  : Container()
                                ],
                              ),
                              Divider(color: white.withOpacity(0.3),)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
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
      ),
    );
  }
}