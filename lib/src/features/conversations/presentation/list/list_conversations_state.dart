// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversationWithMembers.dart';

class ListConversationsState {
  final AsyncValue value;
  final String currentUserUid;
  final List<ConversationWithMembers> conversationsWithUsersObjects;
  ListConversationsState({
    required this.value,
    this.currentUserUid = "",
    this.conversationsWithUsersObjects = const [],
  });

  ListConversationsState copyWith({
    AsyncValue? value,
    String? currentUserUid,
    List<ConversationWithMembers>? conversationsWithUsersObjects,
  }) {
    return ListConversationsState(
      value: value ?? this.value,
      currentUserUid: currentUserUid ?? this.currentUserUid,
      conversationsWithUsersObjects:
          conversationsWithUsersObjects ?? this.conversationsWithUsersObjects,
    );
  }

  @override
  String toString() =>
      'ListConversationsState(value: $value, currentUserUid: $currentUserUid, conversationsWithUsersObjects: $conversationsWithUsersObjects)';

  @override
  bool operator ==(covariant ListConversationsState other) {
    if (identical(this, other)) return true;

    return other.value == value &&
        other.currentUserUid == currentUserUid &&
        listEquals(
            other.conversationsWithUsersObjects, conversationsWithUsersObjects);
  }

  @override
  int get hashCode =>
      value.hashCode ^
      conversationsWithUsersObjects.hashCode ^
      currentUserUid.hashCode;
}
