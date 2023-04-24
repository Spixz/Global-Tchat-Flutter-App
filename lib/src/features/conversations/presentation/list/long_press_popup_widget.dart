import 'package:flutter/material.dart';

class ConversationPopup extends StatelessWidget {
  String conversationId;
  Function(String) deleteConversation;
  ConversationPopup(
      {super.key,
      required this.conversationId,
      required this.deleteConversation});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Options'),
      children: <Widget>[
        ListTile(
          title: const Text('Delete'),
          onTap: () {
            deleteConversation(conversationId);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
