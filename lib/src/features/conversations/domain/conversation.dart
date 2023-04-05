// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Conversation {
  final String id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String ownerId;
  final List<String> members;
  final List<String>? admins;
  final List<String>? banned;
  final String? lastMessage;
  final String? lastMessageSender;
  final DateTime? lastMessageTimeSent;
  final bool? lastMessageRead;

  Conversation({
    required this.id,
    this.name,
    this.description,
    this.imageUrl,
    required this.ownerId,
    required this.members,
    this.admins,
    this.banned,
    this.lastMessage,
    this.lastMessageSender,
    this.lastMessageTimeSent,
    this.lastMessageRead,
  });

  Conversation copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? ownerId,
    List<String>? members,
    List<String>? admins,
    List<String>? banned,
    String? lastMessage,
    String? lastMessageSender,
    DateTime? lastMessageTimeSent,
    bool? lastMessageRead,
  }) {
    return Conversation(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerId: ownerId ?? this.ownerId,
      members: members ?? this.members,
      admins: admins ?? this.admins,
      banned: banned ?? this.banned,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSender: lastMessageSender ?? this.lastMessageSender,
      lastMessageTimeSent: lastMessageTimeSent ?? this.lastMessageTimeSent,
      lastMessageRead: lastMessageRead ?? this.lastMessageRead,
    );
  }

  Map<String, dynamic> toMap({bool withId = true}) {
    return <String, dynamic>{
      ...withId ? {'id': id} : {},
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'members': members,
      'admins': admins,
      'banned': banned,
      'lastMessage': lastMessage,
      'lastMessageSender': lastMessageSender,
      'lastMessageTimeSent': lastMessageTimeSent?.millisecondsSinceEpoch,
      'lastMessageRead': lastMessageRead,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      ownerId: map['ownerId'] as String,
      members: map['members'] != null
          ? (map['members'] as List).map((m) => m as String).toList()
          : [],
      admins: map['admins'] != null
          ? (map['admins'] as List).map((m) => m as String).toList()
          : [],
      banned: map['banned'] != null
          ? (map['banned'] as List).map((m) => m as String).toList()
          : [],
      lastMessage:
          map['lastMessage'] != null ? map['lastMessage'] as String : null,
      lastMessageSender: map['lastMessageSender'] != null
          ? map['lastMessageSender'] as String
          : null,
      lastMessageTimeSent: map['lastMessageTimeSent'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['lastMessageTimeSent'] as int)
          : null,
      lastMessageRead: map['lastMessageRead'] != null
          ? map['lastMessageRead'] as bool
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  // factory Conversation.fromJson(String source) => Conversation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Conversation(id: $id, name: $name, description: $description, imageUrl: $imageUrl, ownerId: $ownerId, members: $members, admins: $admins, banned: $banned, lastMessage: $lastMessage, lastMessageSender: $lastMessageSender, lastMessageTimeSent: $lastMessageTimeSent, lastMessageRead: $lastMessageRead)';
  }

  @override
  bool operator ==(covariant Conversation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.ownerId == ownerId &&
        listEquals(other.members, members) &&
        listEquals(other.admins, admins) &&
        listEquals(other.banned, banned) &&
        other.lastMessage == lastMessage &&
        other.lastMessageSender == lastMessageSender &&
        other.lastMessageTimeSent == lastMessageTimeSent &&
        other.lastMessageRead == lastMessageRead;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        ownerId.hashCode ^
        members.hashCode ^
        admins.hashCode ^
        banned.hashCode ^
        lastMessage.hashCode ^
        lastMessageSender.hashCode ^
        lastMessageTimeSent.hashCode ^
        lastMessageRead.hashCode;
  }
}
