// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/domain/app_user.dart';
// import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/tchat/domain/message.dart';

// class MessageBody extends ConsumerWidget {
//   final Message message;
//   const MessageBody({super.key, required this.message});
//   //TODO: ca serai bien me mettre un provider ici pour aligner en fonction de l'envoyeur

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final connectedUser = ref.watch(userProvider);
//     var size = MediaQuery.of(context).size;
//     bool isSender = (message.senderId == connectedUser.uid);

//     return Align(
//         alignment: (isSender ? Alignment.centerRight : Alignment.centerLeft),
//         child: Container(
//           margin: const EdgeInsets.all(10),
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//               color: (isSender) ? Colors.red : Colors.amber,
//               borderRadius: BorderRadius.circular(10)),
//           constraints: BoxConstraints(
//             maxWidth: size.width * 0.7,
//           ),
//           child: Column(
//               crossAxisAlignment: (isSender
//                   ? CrossAxisAlignment.end
//                   : CrossAxisAlignment.start),
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(message.senderId,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 14)),
//                 const SizedBox(height: 3),
//                 Text(
//                   message.content,
//                 )
//               ]),
//         ));
//   }
// }
