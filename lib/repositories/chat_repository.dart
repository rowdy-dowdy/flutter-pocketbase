// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_pocketbase/models/contact_model.dart';
import 'package:flutter_pocketbase/models/message_model.dart';
import 'package:flutter_pocketbase/models/room_model.dart';
import 'package:flutter_pocketbase/providers/auth_provider.dart';
import 'package:flutter_pocketbase/services/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_pocketbase/models/user_model.dart';
import 'package:flutter_pocketbase/services/dio_service.dart';

class ChatRepository {
  Ref? _ref;
  Dio? dio;

  ChatRepository(Ref ref) {
    _ref = ref;
    dio = ref.read(dioProvider);
  }

  Future<ListMessageModel> fetchData(String? roomId) async {
    try {
      Response response = await dio!.get('/api/v1/messages/$roomId');

      ListMessageModel data = ListMessageModel.fromMap(response.data);

      return data;
      
    } catch (e) {
      print({e});
      return ListMessageModel(messages: []);
    }
  }

  Future<List<MessageModel>> getChatFuture(String roomId) async { 
    try {
      var listMessage = await fetchData(roomId);
      List<MessageModel> messages = listMessage.messages;

      return messages;
    } catch (e) {
      return [];
    }
  }
  
  Stream<List<MessageModel>> getChatStream(String roomId) async* {
    var listMessage = await fetchData(roomId);
    List<MessageModel> messages = listMessage.messages;
    // await Future.delayed(const Duration(seconds: 1));
    // print('stream message $roomId');
    yield messages.reversed.toList();

    // await for (final message in socket.map(utf8.decode)) {
    // // A new message has been received. Let's add it to the list of all messages.
    //   allMessages = [...allMessages, message];
    //   yield allMessages;
    // }
  }
  
  Future sendMessage(String? roomId, String body) async {
    if (roomId == null) return;

    _ref!.read(socketProvider).emit("message", {
      "roomId":  roomId,
      "userId": _ref!.read(authProvider).user!.id,
      "body": body
    });
  }

}

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref);
});