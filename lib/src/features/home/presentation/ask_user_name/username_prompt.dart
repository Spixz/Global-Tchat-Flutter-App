import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/app_router.dart';

class UsernamePrompt extends ConsumerStatefulWidget {
  const UsernamePrompt({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UsernamePromptState();
}

class _UsernamePromptState extends ConsumerState<UsernamePrompt> {
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Please enter your username"),
          const SizedBox(height: 16),
          TextField(
              controller:
                  _usernameController, //TODO: me mettre un provider ici pour stocker le username
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Username",
              ),
              onSubmitted: (value) {
                GoRouter.of(context).pushNamed(AppRoute.globalTchat.name);
              }),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                GoRouter.of(context).pushNamed(AppRoute.globalTchat.name),
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
