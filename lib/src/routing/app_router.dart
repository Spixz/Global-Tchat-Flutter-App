import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/presentation/account_screen.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/presentation/login_register_screen.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/home/presentation/home_screen.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/tchat/presentation/tchat_view.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/go_router_refresh_stream.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/not_found_screen.dart';
import 'package:go_router/go_router.dart';

enum AppRoute { home, login, account, globalTchat }

final goRouterProvider = Provider<GoRouter>((ref) {
  // final userStreamProvider = ref.watch(authRepositoryUserStreamProvider);

  ///TODO: La redirection est évalué 4 fois au démarrage de l'application.
  ///et 2 fois à chaque fois que l'on change de route.

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) async {
      final userStreamProvider =
          ref.read(authRepositoryProvider).authStateChange();
      final value = await userStreamProvider.first;

      final isLogged = value != null;
      debugPrint(
          "Annalyse de la route en cours (actual: ${state.location} | isLogged: $isLogged ):");
      if (isLogged) {
        if (state.location == '/login') {
          debugPrint("Vous êtes déjà connecté, redirection sur /");
          return '/';
        }
      } else {
        if (['/tchat', '/account', '/'].contains(state.location)) {
          debugPrint(
              "Vous avez été redirigé sur le loggin car vous n'avez pas accès au home");
          return '/login';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(
        ref.read(authRepositoryProvider).authStateChange()),
    routes: [
      GoRoute(
          path: '/',
          name: AppRoute.home.name,
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'login',
              name: AppRoute.login.name,
              builder: (context, state) => const LoginRegisterScreen(),
            ),
            GoRoute(
                path: 'account',
                name: AppRoute.account.name,
                builder: (context, state) => const AccountScreen()),
            GoRoute(
                path: 'tchat',
                name: AppRoute.globalTchat.name,
                builder: (context, state) => const TchatView()),
          ])
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});

// GoRoute(
//   path: 'product/:id',
//   name: AppRoute.product.name,
//   builder: (context, state) {
//     final productId = state.params['id']!;
//     return ProductScreen(productId: productId);
//   })
