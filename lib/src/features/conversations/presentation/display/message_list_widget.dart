import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/message.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/display/message_body.dart';
import 'package:visibility_detector/visibility_detector.dart';

//List builder rebuild seuleument les éléments qui ont été ajoutés.
class MessageList extends ConsumerWidget {
  final List<Message> messages;
  final String connectedUserUid;
  void Function(String messageId) changeMessageStatusToSeen;
  MessageList(
      {super.key,
      required this.messages,
      required this.connectedUserUid,
      required this.changeMessageStatusToSeen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;

    return Expanded(
        // height: size.height * 0.90,
        child: ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final reversedIndex = messages.length - 1 - index;
            final message = messages[reversedIndex];
            return VisibilityDetector(
              key: Key(message.content),
              onVisibilityChanged: (visibilityInfo) {
                var visiblePercentage = visibilityInfo.visibleFraction * 100;

                if (message.isSeen == false &&
                    visiblePercentage > 70 &&
                    message.senderId != connectedUserUid) {
                  debugPrint(
                      'Widget $visibilityInfo is $visiblePercentage% visible');
                  changeMessageStatusToSeen(message.id);
                }
              },
              child: MessageBody(
                  message: message, connectedUserUid: connectedUserUid),
            );
          },
        ));
  }
}
