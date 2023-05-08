// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/domain/app_user.dart';
// import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/app_router.dart';

// class UsernamePrompt extends ConsumerStatefulWidget {
//   const UsernamePrompt({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _UsernamePromptState();
// }

// class _UsernamePromptState extends ConsumerState<UsernamePrompt> {
//   late TextEditingController _usernameController;

//   @override
//   void initState() {
//     super.initState();
//     _usernameController =
//         TextEditingController(text: ref.read(userProvider.notifier).state.uid);
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     super.dispose();
//   }

//   void nextScreen(String? username) {
//     if (username != null) {
//       ref.read(userProvider.notifier).state = AppUser(uid: username);
//     }
//     GoRouter.of(context).pushNamed(AppRoute.globalTchat.name);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text("Please enter your username"),
//           const SizedBox(height: 16),
//           TextField(
//               controller:
//                   _usernameController, //TODO: me mettre un provider ici pour stocker le username
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: "Username",
//               ),
//               onSubmitted: (value) => nextScreen(_usernameController.text)),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () => nextScreen(_usernameController.text),
//             child: const Text("Submit"),
//           ),
//         ],
//       ),
//     );
//   }
// }
