// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversationWithMembers.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/message_collection.dart';

class DisplayConversationState {
  final AsyncValue value;
  final String currentUserUid;
  final String conversationId;
  final ConversationWithMembers?
      conversationInformations; //from conversationInformations (group) stream
  final MessageCollection? messagesFromConversation; //from messages stream

  DisplayConversationState({
    required this.value,
    required this.currentUserUid,
    required this.conversationId,
    this.messagesFromConversation,
    this.conversationInformations,
  });

  DisplayConversationState copyWith({
    AsyncValue? value,
    String? currentUserUid,
    String? conversationId,
    ConversationWithMembers? conversationInformations,
    MessageCollection? messagesFromConversation,
  }) {
    return DisplayConversationState(
      value: value ?? this.value,
      currentUserUid: currentUserUid ?? this.currentUserUid,
      conversationId: conversationId ?? this.conversationId,
      conversationInformations:
          conversationInformations ?? this.conversationInformations,
      messagesFromConversation: messagesFromConversation ?? this.messagesFromConversation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
      'currentUserUid': currentUserUid,
      'conversationId': conversationId,
      'conversationInformations': conversationInformations?.toMapSecond(),
      'messagesFromConversation': messagesFromConversation?.toMap(),
    };
  }

  // factory DisplayConversationState.fromMap(Map<String, dynamic> map) {
  //   return DisplayConversationState(
  //     value: AsyncValue.fromMap(map['value'] as Map<String,dynamic>),
  //     currentUserUid: map['currentUserUid'] as String,
  //     conversationId: map['conversationId'] as String,
  //     bindedConversation: map['bindedConversation'] != null ? ConversationWithMembers.fromMap(map['bindedConversation'] as Map<String,dynamic>) : null,
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory DisplayConversationState.fromJson(String source) => DisplayConversationState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DisplayConversationState(value: $value, currentUserUid: $currentUserUid, conversationId: $conversationId, conversationInformations: $conversationInformations, messagesFromConversation: $messagesFromConversation)';
  }

  @override
  bool operator ==(covariant DisplayConversationState other) {
    if (identical(this, other)) return true;

    return other.value == value &&
        other.currentUserUid == currentUserUid &&
        other.conversationId == conversationId &&
        other.conversationInformations == conversationInformations &&
        other.messagesFromConversation == messagesFromConversation;
  }

  @override
  int get hashCode {
    return value.hashCode ^
        currentUserUid.hashCode ^
        conversationId.hashCode ^
        conversationInformations.hashCode ^
        messagesFromConversation.hashCode;
  }
}
