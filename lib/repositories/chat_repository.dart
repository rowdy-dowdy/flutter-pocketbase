// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_pocketbase/models/contact_model.dart';
import 'package:flutter_pocketbase/models/message_model.dart';
import 'package:flutter_pocketbase/models/room_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_pocketbase/models/user_model.dart';
import 'package:flutter_pocketbase/services/dio_service.dart';

class MessageRepository {
  Ref? _ref;
  Dio? dio;

  MessageRepository(Ref ref) {
    _ref = ref;
    dio = ref.read(dioProvider);
  }

  Future<ListMessageModel?> fetchData(String? roomId) async {
    try {
      Response response = await dio!.get('/api/v1/messages/$roomId');

      ListMessageModel data = ListMessageModel.fromMap(response.data);
      print(data.messages);
      return data;
      
    } catch (e) {
      print({e});
      return null;
    }
  }
}

final MessageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepository(ref);
});