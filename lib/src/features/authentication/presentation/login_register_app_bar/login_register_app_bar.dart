import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/localization/string_hardcoded.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom [AppBar] widget that is reused by the [ProductsListScreen] and
/// [ProductScreen].
/// It shows the following actions, depending on the application state:
/// - [ShoppingCartIcon]
/// - Orders button
/// - Account or Sign-in button
class LoginRegisterAppBar extends StatelessWidget with PreferredSizeWidget {
  const LoginRegisterAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Login".hardcoded),
      actions: const [
        // if (GoRouter.of(context).location == AppRoute.home.name) ...[
        //   IconButton(
        //       onPressed: () => GoRouter.of(context).pop(),
        //       icon: const Icon(Icons.favorite))
        // ]
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
