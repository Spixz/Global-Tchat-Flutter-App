// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/common_widgets/empty_widget.dart';
// import 'package:intl/intl.dart';

// class MessagerieAppbar extends ConsumerWidget with PreferredSizeWidget {
//   const MessagerieAppbar({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     var messageStream = ref.watch(messagesStreamProvider);
//     return messageStream.when(
//         data: (messages) {
//           return AppBar(
//               title: const Text("Messagerie"),
//               flexibleSpace: Center(
//                   child: (messages.isNotEmpty)
//                       ? Text(
//                           DateFormat("h:mm:ss a")
//                               .format(messages.last.createdAt),
//                           style: const TextStyle(
//                               fontSize: 18,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w800),
//                         )
//                       : const EmptyWidget()));
//         },
//         loading: () => const EmptyWidget(),
//         error: (error, stack) => Center(child: Text(error.toString())));
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(60.0);
// }
