import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/constants/keys.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/enums/message_type.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversationWithMembers.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/localization/string_hardcoded.dart';

class ConversationTile extends StatefulWidget {
  final String actualUserUid;
  final ConversationWithMembers conversation;

  const ConversationTile(
      {super.key, required this.actualUserUid, required this.conversation});

  @override
  State<ConversationTile> createState() => _ConversationTileState();
}
/*
Titre:
- Titre par défaut
- Si pas de titre:
   2 in grp => afficher le nom de l'autre user
   < 2 users, tronquer tt les contacts

imageUrl:
- Image par défaut //OK
- Si pas image:
  2 users =>
     Si user photo => Photos user
     Si pas user photo => Première lettre blaze
  < 2 users => icon grp  //OK

messages & autres:
- Données par défaut
- Sinon rien

Besoin du nom des participants (uid => blazes) (furure pr le cache)
Besoin de leurs photos
L> Besoin de leurs objets quoi.
Pas opti si +100 part
   L> Récup le dernier sender + 2 autres si grp.


*/

class _ConversationTileState extends State<ConversationTile> {
  late ConversationWithMembers _conversation;
  late List<AppUser> _membersWithoutActualUser;

  @override
  void initState() {
    _conversation = widget.conversation;
    _membersWithoutActualUser = _conversation.membersFilled
        .where((user) => user.uid != widget.actualUserUid)
        .toList();
    super.initState();
  }

  String _getTitle() {
    if (_conversation.name != null) return _conversation.name!;
    if (_conversation.membersFilled.length == 2) {
      return _membersWithoutActualUser.first.username;
    }
    return 'Conversation de groupe'.hardcoded;
  }

  String _getLastMessage() {
    String? lastSender = _conversation.lastMessageSender;
    String? lastMessage = _conversation.lastMessage;

    if (_conversation.lastMessageType == MessageType.image) {
      lastMessage = 'Image'.hardcoded;
    }
    if (lastMessage != null && lastSender != null) {
      return (_conversation.membersFilled.length == 2)
          ? lastMessage
          : "$lastSender: $lastMessage";
    }
    return 'Faites le premier pas ;)'.hardcoded;
  }

  String _getLastMessageDate() {
    if (_conversation.lastMessageTimeSent == null) return "";
    return DateFormat.Hm().format(_conversation.lastMessageTimeSent);
  }

  Widget _getConversationPicture() {
    String? picture = _conversation.imageUrl;
    if (picture != null) {
      return CircleAvatar(
        key: keyConversationPictureNull,
        backgroundImage: NetworkImage(picture),
        radius: 30,
      );
    }
    if (_conversation.membersFilled.length == 2) {
      if (_membersWithoutActualUser.first.profilePic.isNotEmpty) {
        return CircleAvatar(
          key: keyConversationPictureOfUser,
          backgroundImage: NetworkImage(
            _membersWithoutActualUser.first.profilePic,
          ),
          radius: 30,
        );
      }
    }
    if (_conversation.membersFilled.length > 2) {
      return const Icon(
          key: keyConversationPictureGroupConversation, Icons.groups, size: 30);
    }
    return const Icon(
        key: keyConversationPictureDefault, Icons.account_circle, size: 30);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _getTitle(),
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Text(
          _getLastMessage(),
          style: const TextStyle(fontSize: 15),
        ),
      ),
      leading: _getConversationPicture(),
      trailing: Text(
        _getLastMessageDate(),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    );
  }
}
