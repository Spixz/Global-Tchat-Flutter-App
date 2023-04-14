import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PromptUserMessage extends ConsumerStatefulWidget {
  final void Function(String) submitMessage;
  const PromptUserMessage({super.key, required this.submitMessage});

  @override
  ConsumerState<PromptUserMessage> createState() => _PromptUserMessageState();
}

class _PromptUserMessageState extends ConsumerState<PromptUserMessage> {
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
        onSubmitted: (msg) => widget.submitMessage(msg),
      ),
    ));
  }
}
