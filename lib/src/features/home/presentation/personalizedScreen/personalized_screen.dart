import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows the product page for a given product ID.
class PersonalizedScreen extends ConsumerWidget {
  const PersonalizedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        // appBar: const HomeAppBar(),
        body: Consumer(builder: (context, ref, child) {
      return const Center(child: Text("Hi"));
    }));
  }
}
