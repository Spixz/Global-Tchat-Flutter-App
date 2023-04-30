import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/presentation/account_screen.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/presentation/login_register_screen.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/create/create_conversation_view.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/display/display_conversation_view.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/list/list_conversations_view.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/go_router_refresh_stream.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/not_found_screen.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/redirections.dart';

enum AppRoute {
  home,
  login,
  account,
  createConversation,
  listConversations,
  displayConversation,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) => routerRedirections(
        context, state, ref.read(authRepositoryProvider).authStateChange()),
    refreshListenable: GoRouterRefreshStream(
        ref.read(authRepositoryProvider).authStateChange()),
    routes: [
      GoRoute(
          path: '/',
          name: AppRoute.listConversations.name,
          builder: (context, state) => const ListConversations(),
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
                path: 'createConversation',
                name: AppRoute.createConversation.name,
                builder: (context, state) => const CreateNewConversation()),
            // GoRoute(
            //     path: 'listConversations',
            //     name: AppRoute.listConversations.name,
            //     builder: (context, state) => const ListConversations()),
            GoRoute(
                path: 'displayConversation/:id',
                name: AppRoute.displayConversation.name,
                builder: (context, state) {
                  final conversationId = state.params['id'];
                  print(conversationId);
                  //ConversationWithMembers conversation = state.params['conversationBinded']; //from json
                  return DisplayConversation(conversationId: conversationId);
                }),
          ])
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
