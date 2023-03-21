import 'package:flutter/material.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/tchat/presentation/message_appbar.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/tchat/presentation/prompt_user_message.dart';

class TchatView extends StatefulWidget {
  const TchatView({super.key});

  @override
  State<TchatView> createState() => _TchatViewState();
}

class _TchatViewState extends State<TchatView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const MessagerieAppbar(),
      body: Column(
        children: const [/*MessageList()*/ PromptUserMessage()],
      ),
    );
  }
}
