import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversationBinded.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/localization/string_hardcoded.dart';

class ConversationTile extends StatefulWidget {
  final String actualUserUid;
  final ConversationWithMembers conversation;
  late List<AppUser> membersWithoutActualUser;
  ConversationTile(
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
  @override
  void initState() {
    widget.membersWithoutActualUser = widget.conversation.membersFilled
        .where((user) => user.uid != widget.actualUserUid)
        .toList();
    super.initState();
  }

//Return the list of the members without the actual connected user.
  // List<AppUser> get membersWithoutActualUser =>

//faut que je fasse une fonction qui récupère à coup sur le second utilisateur.
  String _getTitle() {
    if (widget.conversation.name != null) return widget.conversation.name!;
    if (widget.conversation.membersFilled.length == 2) {
      return widget.membersWithoutActualUser.first.username;
    }
    return 'Conversation de groupe'.hardcoded;
  }

  String _getLastMessage() {
    String? lastSender = widget.conversation.lastMessageSender;
    String? lastMessage = widget.conversation.lastMessage;
    if (lastMessage != null && lastSender != null) {
      if (widget.conversation.membersFilled.length == 2) {
        return lastMessage;
      }
      return "$lastSender: $lastMessage";
    }
    return 'Faites le premier pas ;)'.hardcoded;
  }

  String _getLastMessageDate() {
    if (widget.conversation.lastMessageTimeSent == null) return "";
    return DateFormat.Hm().format(widget.conversation.lastMessageTimeSent!);
  }

  Widget _getConversationPicture() {
    String? picture = widget.conversation.imageUrl;
    if (picture != null) {}
    if (widget.conversation.membersFilled.length == 2) {
      if (widget.membersWithoutActualUser.first.profilePic.isNotEmpty) {
        return CircleAvatar(
          backgroundImage: NetworkImage(
            widget.membersWithoutActualUser.first.profilePic,
          ),
          radius: 30,
        );
      }
    }
    if (widget.conversation.membersFilled.length > 2) {
      return const Icon(Icons.groups, size: 30);
    }
    return const Icon(Icons.account_circle, size: 30);
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
