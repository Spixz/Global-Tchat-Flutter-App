import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/constants/colors.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/presentation/account_controller.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/localization/string_hardcoded.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/app_router.dart';

class AppBarMenu extends ConsumerWidget with PreferredSizeWidget {
  final String title;
  final bool menuEnabled;
  const AppBarMenu({super.key, required this.title, this.menuEnabled = true});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(title),
      backgroundColor: appBarColor,
      actions: (menuEnabled)
          ? [
              PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<String>>[
                        PopupMenuItem<String>(
                            value: AppRoute.account.name,
                            child: Text('Account'.hardcoded)),
                        PopupMenuItem<String>(
                            value: AppRoute.login.name,
                            child: Text('Logout'.hardcoded)),
                        // PopupMenuItem<String>(
                        //     value: AppRoute.home.name,
                        //     child: Text('Home'.hardcoded)),
                      ],
                  onSelected: (String value) async {
                    if (value == AppRoute.login.name) {
                      await ref
                          .read(accountControllerProvider.notifier)
                          .signOut();
                    }
                    GoRouter.of(context).pushNamed(value);
                  })
            ]
          : [],
    );
  }
}
