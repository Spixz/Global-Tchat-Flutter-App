import 'package:flutter/material.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/constants/test_messages.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/tchat/presentation/message_body.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: kTestMessage.length,
      itemBuilder: (context, index) {
        return MessageBody(message: kTestMessage[index]);
      },
    );
  }
}
