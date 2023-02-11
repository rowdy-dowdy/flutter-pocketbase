// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_pocketbase/models/message_model.dart';
import 'package:flutter_pocketbase/models/room_model.dart';
import 'package:flutter_pocketbase/models/user_model.dart';
import 'package:flutter_pocketbase/pages/chat_screen.dart';
import 'package:flutter_pocketbase/repositories/chat_repository.dart';
import 'package:flutter_pocketbase/repositories/room_repository.dart';

class RoomChat extends Equatable {
  final String roomId;
  List<MessageModel> messages;
  List<UserModel> users;
  int page;
  bool loading;

  RoomChat({
    required this.roomId,
    required this.messages,
    required this.users,
    this.page = 1,
    this.loading = false
  });

  RoomChat.unknown()
    : roomId = "",
      messages = [],
      users = [],
      page = 1,
      loading = false;

  RoomChat copyWithLoading (bool loading) {
    return RoomChat(roomId: roomId, messages: messages, users: users, loading: loading);
  }

  RoomChat addMessages (ListMessageModel list) {
    return RoomChat(roomId: roomId, messages: list.messages, users: users, loading: loading);
  }

  @override
  List<Object> get props {
    return [
      roomId,
      messages,
      users,
      page,
      loading,
    ];
  }
}

class ChatNotifier extends StateNotifier<RoomChat> {
  final Ref ref;
  final String roomId;

  ChatNotifier(this.ref, this.roomId): super(RoomChat.unknown());
  
  Future<void> getRoomData() async {
    state = state.copyWithLoading(true);

    RoomChat? room = null;
    if (state.roomId == "") {

      final data = await ref.read(roomRepositoryProvider).fetchRoomById(roomId);
  
      if (data != null) {
        room = RoomChat(roomId: roomId, messages: [], users: data.users);
      }
      else {
        state = state.copyWithLoading(false);
        return;
      }
    }
    else {
      room = state;
    }

    ListMessageModel data = await ref.read(chatRepositoryProvider).fetchData(roomId);

    state = room.addMessages(data);

    state = state.copyWithLoading(false);
  }
}

final chatProvider = StateNotifierProvider.family<ChatNotifier, RoomChat, String>((ref, roomId) {
  return ChatNotifier(ref, roomId);
});

final chatStreamProvider = StreamProvider.autoDispose.family<List<MessageModel>, String>((ref, roomId) {
  return ref.read(chatRepositoryProvider).getChatStream(roomId);
});