import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/home/presentation/ask_user_name/login_register_screen.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/tchat/presentation/tchat_view.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/not_found_screen.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home,
  globalTchat
  // product,
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const AskUserNameScreen(),
        routes: [
          GoRoute(
              path: 'tchat',
              name: AppRoute.globalTchat.name,
              builder: (context, state) => const TchatView()),
        ])
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);

 // GoRoute(
          //   path: 'product/:id',
          //   name: AppRoute.product.name,
          //   builder: (context, state) {
          //     final productId = state.params['id']!;
          //     return ProductScreen(productId: productId);
          //   })