// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/enums/message_type.dart';

class Message {
  final String id;
  final String content;
  final String senderId;
  final DateTime createdAt;
  final MessageType type;
  final bool isSeen;
  final String repliedTo;
  final String repliedMessage; //Il le stock pour pas avoir à call je pense.
  final MessageType repliedMessageType;

  Message({
    required this.id, //facultatif
    required this.content,
    required this.senderId,
    required this.createdAt,
    required this.type,
    required this.isSeen,
    required this.repliedTo,
    required this.repliedMessage,
    required this.repliedMessageType,
  });

  Message copyWith({
    String? id,
    String? content,
    String? senderId,
    DateTime? createdAt,
    MessageType? type,
    bool? isSeen,
    String? repliedTo,
    String? repliedMessage,
    MessageType? repliedMessageType,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      isSeen: isSeen ?? this.isSeen,
      repliedTo: repliedTo ?? this.repliedTo,
      repliedMessage: repliedMessage ?? this.repliedMessage,
      repliedMessageType: repliedMessageType ?? this.repliedMessageType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'senderId': senderId,
      'createdAt': Timestamp.fromDate(createdAt),
      'type': type.toString(),
      'isSeen': isSeen,
      'repliedTo': repliedTo,
      'repliedMessage': repliedMessage,
      'repliedMessageType': repliedMessageType.toString(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      content: map['content'] as String,
      senderId: map['senderId'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      type: MessageType.values.byName(map['type']),
      isSeen: map['isSeen'] as bool,
      repliedTo: map['repliedTo'] as String,
      repliedMessage: map['repliedMessage'] as String,
      repliedMessageType: MessageType.values.byName(map['repliedMessageType']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(id: $id, content: $content, senderId: $senderId, createdAt: $createdAt, type: $type, isSeen: $isSeen, repliedTo: $repliedTo, repliedMessage: $repliedMessage, repliedMessageType: $repliedMessageType)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.content == content &&
        other.senderId == senderId &&
        other.createdAt == createdAt &&
        other.type == type &&
        other.isSeen == isSeen &&
        other.repliedTo == repliedTo &&
        other.repliedMessage == repliedMessage &&
        other.repliedMessageType == repliedMessageType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        content.hashCode ^
        senderId.hashCode ^
        createdAt.hashCode ^
        type.hashCode ^
        isSeen.hashCode ^
        repliedTo.hashCode ^
        repliedMessage.hashCode ^
        repliedMessageType.hashCode;
  }
}
