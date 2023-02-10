// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_pocketbase/models/contact_model.dart';
import 'package:flutter_pocketbase/models/room_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_pocketbase/models/user_model.dart';
import 'package:flutter_pocketbase/services/dio_service.dart';

class RoomRepository {
  Ref? _ref;
  Dio? dio;

  RoomRepository(Ref ref) {
    _ref = ref;
    dio = ref.read(dioProvider);
  }

  Future<ListRoomModel?> fetchRoom() async {
    try {
      Response response = await dio!.get('/api/v1/rooms');
      print(response.data);
      ListRoomModel contacts = ListRoomModel.fromMap(response.data);
      
      return contacts;
      
    } catch (e) {
      print({e});
      return null;
    }
  }
}

final roomRepositoryProvider = Provider<RoomRepository>((ref) {
  return RoomRepository(ref);
});