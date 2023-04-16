import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/message.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/display/message_body.dart';

//List builder rebuild seuleument les éléments qui ont été ajoutés.
class MessageList extends ConsumerWidget {
  final List<Message> messages;
  final String connectedUserUid;
  const MessageList(
      {super.key, required this.messages, required this.connectedUserUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;

    return SizedBox(
        height: size.height * 0.90,
        child: ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final reversedIndex = messages.length - 1 - index;
            final message = messages[reversedIndex];
            return MessageBody(
                message: message, connectedUserUid: connectedUserUid);
          },
        ));
  }
}
