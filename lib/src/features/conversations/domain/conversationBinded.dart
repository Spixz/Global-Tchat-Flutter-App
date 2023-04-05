// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversation.dart';

/*
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
*/

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
    return 'Conversation(id: $id, name: $name, description: $description, imageUrl: $imageUrl, ownerId: $ownerId, members: $membersFilled, admins: $admins, banned: $banned, lastMessage: $lastMessage, lastMessageSender: $lastMessageSender, lastMessageTimeSent: $lastMessageTimeSent, lastMessageRead: $lastMessageRead)';
  }
}
