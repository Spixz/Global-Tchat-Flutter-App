import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/home/presentation/personalizedScreen/personalized_screen.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/not_found_screen.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home,
  // product,
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const PersonalizedScreen(),
        routes: const [
          // GoRoute(
          //   path: 'product/:id',
          //   name: AppRoute.product.name,
          //   builder: (context, state) {
          //     final productId = state.params['id']!;
          //     return ProductScreen(productId: productId);
          //   })
        ])
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);
