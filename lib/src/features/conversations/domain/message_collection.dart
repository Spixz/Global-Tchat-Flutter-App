// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/message.dart';

class MessageCollection {
  final String id; //correspond to group id
  final List<Message> messages;

  MessageCollection({
    required this.id,
    List<Message>? messages,
  }) : messages = messages ?? <Message>[];

  MessageCollection copyWith({
    String? id,
    List<Message>? messages,
  }) {
    return MessageCollection(
      id: id ?? this.id,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'messages': messages.map((x) => x.toMap()).toList(),
    };
  }

  factory MessageCollection.fromMap(Map<String, dynamic> map) {
    return MessageCollection(
      id: map['id'] as String,
      messages: (map['messages'] as List).map((e) {
        // print(e);
        return Message.fromMap(e);
      }).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageCollection.fromJson(String source) =>
      MessageCollection.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MessageCollection(id: $id, messages: $messages)';

  @override
  bool operator ==(covariant MessageCollection other) {
    if (identical(this, other)) return true;

    return other.id == id && listEquals(other.messages, messages);
  }

  @override
  int get hashCode => id.hashCode ^ messages.hashCode;
}
