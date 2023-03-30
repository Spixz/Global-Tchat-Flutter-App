import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const Center(child: Text("Tu es connecté")),
        TextButton(
            onPressed: () =>
                GoRouter.of(context).pushNamed(AppRoute.account.name),
            child: const Text("=> Account"))
      ],
    ));
  }
}
