import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/message.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/display/display_conversation_controller.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/display/message_list_widget.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/display/prompt_user_message.dart';

class DisplayConversation extends ConsumerStatefulWidget {
  final conversationId;
  const DisplayConversation({super.key, required this.conversationId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DisplayConversationsState();
}

class _DisplayConversationsState extends ConsumerState<DisplayConversation> {
  void submitMessage(String message) {
    print("Envoie du message");
    ref
        .read(displayConversationControllerProvider(widget.conversationId)
            .notifier)
        .sendMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    final state =
        ref.watch(displayConversationControllerProvider(widget.conversationId));

    return Scaffold(
      // appBar: const MessagerieAppbar(),
      body: Column(
        children: [
          MessageList(
              messages:
                  state.messagesCollection?.messages ?? List<Message>.from([])),
          PromptUserMessage(submitMessage: submitMessage),
          // Text("Group name : ${state.bindedConversation?.name}"),
        ],
      ),
    );
  }
}
