// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_pocketbase/models/user_model.dart';

class RoomModel {
  final String id;
  final List<UserModel> users;
  
  RoomModel({
    required this.id,
    required this.users,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'users': users.map((x) => x.toMap()).toList(),
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'] as String,
      users: List<UserModel>.from((map['users'] as List<dynamic>).map<UserModel>((x) => UserModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) => RoomModel.fromMap(json.decode(source) as Map<String, dynamic>);
}


class ListRoomModel {
  final List<RoomModel> rooms;
  ListRoomModel({
    required this.rooms,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rooms': rooms.map((x) => x.toMap()).toList(),
    };
  }

  factory ListRoomModel.fromMap(Map<String, dynamic> map) {
    return ListRoomModel(
      rooms: List<RoomModel>.from((map['rooms'] as List<dynamic>).map<RoomModel>((x) => RoomModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListRoomModel.fromJson(String source) => ListRoomModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
