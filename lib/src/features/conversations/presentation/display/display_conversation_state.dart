// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversationBinded.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/message_collection.dart';

class DisplayConversationState {
  final AsyncValue value;
  final String currentUserUid;
  final String conversationId;
  final ConversationWithMembers? bindedConversation;
  final MessageCollection? messagesCollection;

  DisplayConversationState({
    required this.value,
    required this.currentUserUid,
    required this.conversationId,
    this.messagesCollection,
    this.bindedConversation,
  });

  DisplayConversationState copyWith({
    AsyncValue? value,
    String? currentUserUid,
    String? conversationId,
    ConversationWithMembers? bindedConversation,
    MessageCollection? messagesCollection,
  }) {
    return DisplayConversationState(
      value: value ?? this.value,
      currentUserUid: currentUserUid ?? this.currentUserUid,
      conversationId: conversationId ?? this.conversationId,
      bindedConversation: bindedConversation ?? this.bindedConversation,
      messagesCollection: messagesCollection ?? this.messagesCollection,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
      'currentUserUid': currentUserUid,
      'conversationId': conversationId,
      'bindedConversation': bindedConversation?.toMapSecond(),
      'messagesCollection': messagesCollection?.toMap(),
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
    return 'DisplayConversationState(value: $value, currentUserUid: $currentUserUid, conversationId: $conversationId, bindedConversation: $bindedConversation, messageCollection: $messagesCollection)';
  }

  @override
  bool operator ==(covariant DisplayConversationState other) {
    if (identical(this, other)) return true;

    return other.value == value &&
        other.currentUserUid == currentUserUid &&
        other.conversationId == conversationId &&
        other.bindedConversation == bindedConversation &&
        other.messagesCollection == messagesCollection;
  }

  @override
  int get hashCode {
    return value.hashCode ^
        currentUserUid.hashCode ^
        conversationId.hashCode ^
        bindedConversation.hashCode ^
        messagesCollection.hashCode;
  }
}
