import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/home/presentation/ask_user_name/username_prompt.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/home/presentation/home_app_bar/home_app_bar.dart';

/// Shows the product page for a given product ID.
class AskUserNameScreen extends ConsumerWidget {
  const AskUserNameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: const HomeAppBar(),
        body: Consumer(builder: (context, ref, child) {
          return const UsernamePrompt();
        }));
  }
}
