import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/common_widgets/loading_widget.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/enums/message_type.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/message.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class MessageBody extends ConsumerWidget {
  final Message message;
  final String connectedUserUid;

  const MessageBody(
      {super.key, required this.message, required this.connectedUserUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final connectedUser = ref.watch(userProvider);
    var size = MediaQuery.of(context).size;
    bool isSender = message.senderId == connectedUserUid;
    bool isOpenable = true;

    return Align(
        alignment: (isSender ? Alignment.centerRight : Alignment.centerLeft),
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: (isSender) ? Colors.red : Colors.amber,
              borderRadius: BorderRadius.circular(10)),
          constraints: BoxConstraints(
            maxWidth: size.width * 0.7,
          ),
          child: Column(
              crossAxisAlignment: (isSender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start),
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message.senderUsername,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 3),
                if (message.type == MessageType.text)
                  Text(
                    message.content,
                  ),
                if (message.type == MessageType.image)
                  CachedNetworkImage(
                    imageUrl: message.content,
                    placeholder: (context, url) => const LoadingWidget(),
                    imageBuilder:
                        (BuildContext context, ImageProvider imageProvider) {
                      return GestureDetector(
                        onTap: () {
                          showImageViewer(context, imageProvider,
                              doubleTapZoomable: true, swipeDismissible: true);
                        },
                        child: Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    errorWidget: (context, url, error) => Row(
                        mainAxisSize: MainAxisSize.min,
                        textDirection: TextDirection.rtl,
                        children: const [
                          Icon(Icons.error),
                          SizedBox(width: 5),
                          Text("Impossible de charger l'image")
                        ]),
                  ),
              ]),
        ));
  }
}
