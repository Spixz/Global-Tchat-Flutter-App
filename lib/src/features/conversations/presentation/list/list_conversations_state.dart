// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversation.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversationBinded.dart';

class ListConversationsState {
  final AsyncValue value;
  final String currentUserUid;
  final List<ConversationWithMembers> bindedConversations;
  ListConversationsState({
    required this.value,
    this.currentUserUid = "",
    this.bindedConversations = const [],
  });

  ListConversationsState copyWith({
    AsyncValue? value,
    String? currentUserUid,
    List<Conversation>? conversations,
    List<ConversationWithMembers>? bindedConversations,
  }) {
    return ListConversationsState(
      value: value ?? this.value,
      currentUserUid: currentUserUid ?? this.currentUserUid,
      bindedConversations: bindedConversations ?? this.bindedConversations,
    );
  }

  @override
  String toString() =>
      'ListConversationsState(value: $value, currentUserUid: $currentUserUid, bindedConversations: $bindedConversations)';

  @override
  bool operator ==(covariant ListConversationsState other) {
    if (identical(this, other)) return true;

    return other.value == value &&
        other.currentUserUid == currentUserUid &&
        listEquals(other.bindedConversations, bindedConversations);
  }

  @override
  int get hashCode =>
      value.hashCode ^ bindedConversations.hashCode ^ currentUserUid.hashCode;
}
