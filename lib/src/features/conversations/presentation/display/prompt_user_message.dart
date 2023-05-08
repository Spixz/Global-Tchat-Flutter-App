import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

class PromptUserMessage extends ConsumerStatefulWidget {
  final void Function(String) submitMessage;
  final void Function(String, Uint8List) sendFile;
  const PromptUserMessage(
      {super.key, required this.submitMessage, required this.sendFile});

  @override
  ConsumerState<PromptUserMessage> createState() => _PromptUserMessageState();
}

class _PromptUserMessageState extends ConsumerState<PromptUserMessage> {
  late TextEditingController _usernameController;
  late FocusNode promptFocusNode;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    promptFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void selectAndSendFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'gif', 'svg', 'bmp'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String filename = result.files.first.name;
      widget.sendFile('upload/$filename', fileBytes!);
    }
  }

  void submitMessage(String msg) {
    widget.submitMessage(msg);
    _usernameController.clear();
    promptFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 50, maxHeight: 60),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 15),
              child: TextField(
                  controller: _usernameController,
                  focusNode: promptFocusNode,
                  decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.emoji_emotions_outlined,
                      //     color: Colors.grey),
                      suffixIcon: IconButton(
                          onPressed: () {
                            selectAndSendFile();
                          },
                          icon: const Icon(Icons.camera_alt,
                              color: Colors
                                  .grey)), //Icon(Icons.attach_file, color: Colors.grey),
                      hintText: "Message",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide:
                              BorderSide(width: 0, style: BorderStyle.none)),
                      contentPadding: const EdgeInsets.only(left: 20),
                      fillColor: Colors.white,
                      filled: true),
                  onSubmitted: (text) => submitMessage(text)),
            ),
          ),
          // IconButton(
          //     onPressed: () {
          //       selectAndSendFile();
          //     },
          //     icon: const Icon(Icons.camera_alt, color: Colors.grey)),
        ],
      ),
    );
  }
}
