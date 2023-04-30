import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/presentation/account_controller.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/localization/string_hardcoded.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/app_router.dart';

class AppBarMenu extends ConsumerWidget with PreferredSizeWidget {
  final String title;
  const AppBarMenu({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(title),
      actions: [
        PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                      value: AppRoute.account.name,
                      child: Text('Account'.hardcoded)),
                  PopupMenuItem<String>(
                      value: 'Logout'.hardcoded,
                      child: Text('Logout'.hardcoded)),
                ],
            onSelected: (String value) {
              if (value == 'Logout') {
                ref.read(accountControllerProvider.notifier).signOut();
              }
              GoRouter.of(context).pushReplacementNamed(value);
            })
      ],
    );
  }
}
