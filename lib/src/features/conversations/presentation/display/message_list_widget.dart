import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/data/message_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/message.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/display/message_body.dart';

//List builder rebuild seuleument les éléments qui ont été ajoutés.
class MessageList extends ConsumerWidget {
  final List<Message> messages;
  const MessageList({super.key, required this.messages});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    // var messagesStream = ref.watch(messagesStreamProvider);
    // var messagesStream = ref.watch(messagesFutureProvider);
    //A partir du moment ou on watch un streamProvider, tt le widget est rebuild

    return SizedBox(
        height: size.height * 0.85,
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return MessageBody(message: messages[index]);
          },
        ));
  }
}
