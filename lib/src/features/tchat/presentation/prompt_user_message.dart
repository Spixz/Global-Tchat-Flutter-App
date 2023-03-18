import 'package:flutter/material.dart';

class PromptUserMessage extends StatefulWidget {
  const PromptUserMessage({super.key});

  @override
  State<PromptUserMessage> createState() => _PromptUserMessageState();
}

class _PromptUserMessageState extends State<PromptUserMessage> {
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            ),
            onSubmitted: (value) {
              //GoRouter.of(context).pushNamed(AppRoute.globalTchat.name);
            }),
      ),
    );
  }
}
