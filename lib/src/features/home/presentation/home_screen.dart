import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); //const

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    print("In Home Sceen");
    return Scaffold(
      body: Column(
        children: [
          const Center(child: Text("Tu es connecté")),
          TextButton(
              onPressed: () => GoRouter.of(context)
                  .pushReplacementNamed(AppRoute.account.name),
                  // .pushReplacementNamed(AppRoute.account.name),
              child: const Text("=> Account"))
        ],
      ),
    );
  }
}
