import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/presentation/account_screen.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/presentation/login_register_screen.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/create/create_conversation_view.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/display/display_conversation_view.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/list/list_conversations_view.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/home/presentation/home_screen.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/go_router_refresh_stream.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/not_found_screen.dart';

enum AppRoute {
  home,
  login,
  account,
  createConversation,
  listConversations,
  displayConversation,
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/listConversations',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: false,
    redirect: (context, state) async {
      //TODO: La mettre ailleur
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
        if ([
          '/account',
          '/',
          '/createConversation',
          '/listConversations',
          'displayConversation',
        ].contains(state.location)) {
          //TODO: add createGroup
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
      ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return ScaffoldWithBottomNavBar(child: child);
          },
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
                      path: 'createConversation',
                      name: AppRoute.createConversation.name,
                      builder: (context, state) =>
                          const CreateNewConversation()),
                  GoRoute(
                      path: 'listConversations',
                      name: AppRoute.listConversations.name,
                      builder: (context, state) => const ListConversations()),
                  GoRoute(
                      path: 'displayConversation/:id',
                      name: AppRoute.displayConversation.name,
                      builder: (context, state) {
                        final conversationId = state.params['id'];
                        print(conversationId);
                        //ConversationWithMembers conversation = state.params['conversationBinded']; //from json
                        return DisplayConversation(
                            conversationId: conversationId);
                      }),
                ])
          ])
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});

const tabs = [
  ScaffoldWithNavBarTabItem(
    initialLocation: '/listConversations',
    icon: Icon(Icons.home),
    label: 'Conversations',
  ),
  ScaffoldWithNavBarTabItem(
    initialLocation: '/account',
    icon: Icon(Icons.settings),
    label: 'Profile',
  ),
];

class ScaffoldWithNavBarTabItem extends BottomNavigationBarItem {
  const ScaffoldWithNavBarTabItem(
      {required this.initialLocation, required Widget icon, String? label})
      : super(icon: icon, label: label);

  /// The initial location/path
  final String initialLocation;
}

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({Key? key, required this.child})
      : super(key: key);
  final Widget child;

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  // getter that computes the current index from the current location,
  // using the helper method below
  int get _currentIndex => _locationToTabIndex(GoRouter.of(context).location);

  int _locationToTabIndex(String location) {
    final index =
        tabs.indexWhere((t) => location.startsWith(t.initialLocation));
    // if index not found (-1), return 0
    return index < 0 ? 0 : index;
  }

  // callback used to navigate to the desired tab
  void _onItemTapped(BuildContext context, int tabIndex) {
    if (tabIndex != _currentIndex) {
      // go to the initial location of the selected tab (by index)
      context.go(tabs[tabIndex].initialLocation);
      // GoRouter.of(context).pushReplacementNamed(tabs[tabIndex].initialLocation);
      // GoRouter.of(context).go()
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Current index: $_currentIndex");
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: tabs,
        onTap: (index) => _onItemTapped(context, index),
        selectedIconTheme:
            const IconThemeData(color: Colors.amberAccent, size: 40),
        selectedItemColor: Colors.amberAccent,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
