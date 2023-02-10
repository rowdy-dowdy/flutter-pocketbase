import 'dart:convert';

import 'package:flutter_pocketbase/models/user_model.dart';

class ContactModel {
  final List<UserModel> users;
  ContactModel({
    required this.users,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'users': users.map((x) => x.toMap()).toList(),
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      users: List<UserModel>.from((map['users'] as List<dynamic>).map<UserModel>((x) => UserModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) => ContactModel.fromMap(json.decode(source) as Map<String, dynamic>);
}