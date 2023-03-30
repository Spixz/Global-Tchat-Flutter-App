// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/common_widgets/async_value_widget.dart';
// import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/tchat/data/message_repository.dart';
// import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/tchat/presentation/message_body.dart';

// //List builder rebuild seuleument les éléments qui ont été ajoutés.
// class MessageList extends ConsumerWidget {
//   const MessageList({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     var size = MediaQuery.of(context).size;
//     var messagesStream = ref.watch(messagesStreamProvider);
//     // var messagesStream = ref.watch(messagesFutureProvider);
//     //A partir du moment ou on watch un streamProvider, tt le widget est rebuild

//     return AsyncValueWidget(
//         value: messagesStream,
//         widget: (messages) {
//           return SizedBox(
//               height: size.height * 0.85,
//               child: ListView.builder(
//                 itemCount: messages.length,
//                 itemBuilder: (context, index) {
//                   return MessageBody(message: messages[index]);
//                 },
//               ));
//         });

//     return messagesStream.when(
//         data: (messages) {
//           return SizedBox(
//               height: size.height * 0.85,
//               child: ListView.builder(
//                 itemCount: messages.length,
//                 itemBuilder: (context, index) {
//                   return MessageBody(message: messages[index]);
//                 },
//               ));
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => Center(child: Text(error.toString())));
//   }
// }
