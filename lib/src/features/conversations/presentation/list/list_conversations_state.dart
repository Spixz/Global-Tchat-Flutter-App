// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversation.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversationBinded.dart';

class ListConversationsState {
  final AsyncValue value;
  final List<Conversation> conversations;
  final List<ConversationWithMembers> bindedConversations;
  ListConversationsState({
    required this.value,
    this.conversations = const [],
    this.bindedConversations = const [],
  });

  ListConversationsState copyWith({
    AsyncValue? value,
    List<Conversation>? conversations,
    List<ConversationWithMembers>? bindedConversations,
  }) {
    return ListConversationsState(
      value: value ?? this.value,
      conversations: conversations ?? this.conversations,
      bindedConversations: bindedConversations ?? this.bindedConversations,
    );
  }

  @override
  String toString() =>
      'ListConversationsState(value: $value, conversations: $conversations, bindedConversations: $bindedConversations)';

  @override
  bool operator ==(covariant ListConversationsState other) {
    if (identical(this, other)) return true;

    return other.value == value &&
        listEquals(other.conversations, conversations) &&
        listEquals(other.bindedConversations, bindedConversations);
  }

  @override
  int get hashCode =>
      value.hashCode ^ conversations.hashCode ^ bindedConversations.hashCode;
}
