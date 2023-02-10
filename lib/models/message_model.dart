import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageModel {
  final String id;
  final String senderID;
  final bool isRead;
  final String body;
  final String roomId;
  final String createdAt;
  final String updatedAt;
  MessageModel({
    required this.id,
    required this.senderID,
    required this.isRead,
    required this.body,
    required this.roomId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderID': senderID,
      'isRead': isRead,
      'body': body,
      'roomId': roomId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      senderID: map['senderID'] as String,
      isRead: map['isRead'] as bool,
      body: map['body'] as String,
      roomId: map['roomId'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ListMessageModel {
  final List<MessageModel> messages;
  ListMessageModel({
    required this.messages,
  });
  
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messages': messages.map((x) => x.toMap()).toList(),
    };
  }

  factory ListMessageModel.fromMap(Map<String, dynamic> map) {
    return ListMessageModel(
      messages: List<MessageModel>.from((map['messages'] as List<dynamic>).map<MessageModel>((x) => MessageModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListMessageModel.fromJson(String source) => ListMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
