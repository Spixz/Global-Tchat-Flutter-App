// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversation.dart';

//Comme l'obj conversation mais avec membersFilled en plus
class ConversationWithMembers extends Conversation {
  final List<AppUser> membersFilled;
  ConversationWithMembers(Conversation conv, this.membersFilled)
      : super(
          id: conv.id,
          ownerId: conv.ownerId,
          members: conv.members,
          name: conv.name,
          description: conv.description,
          imageUrl: conv.imageUrl,
          admins: conv.admins,
          banned: conv.banned,
          lastMessage: conv.lastMessage,
          lastMessageSender: conv.lastMessageSender,
          lastMessageTimeSent: conv.lastMessageTimeSent,
          lastMessageRead: conv.lastMessageRead,
        );

  @override
  String toString() {
    return 'ConversationWithMembers(id: $id, name: $name, description: $description, imageUrl: $imageUrl, ownerId: $ownerId, members: $membersFilled, admins: $admins, banned: $banned, lastMessage: $lastMessage, lastMessageSender: $lastMessageSender, lastMessageTimeSent: $lastMessageTimeSent, lastMessageRead: $lastMessageRead)';
  }

  Map<String, dynamic> toMapSecond() {
    return <String, dynamic>{
      'membersFilled': membersFilled.map((user) => user.toMap()).toList(),
      ...super.toMap(),
    };
  }

  @override
  String toJson() => json.encode(toMapSecond());

  @override
  bool operator ==(covariant ConversationWithMembers other) {
    if (identical(this, other)) return true;

    return listEquals(other.membersFilled, membersFilled) &&
        (super.hashCode == other.hashCode);
  }

  int get hashCodeParent => super.hashCode ^ membersFilled.hashCode;
}
