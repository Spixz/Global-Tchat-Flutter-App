import 'dart:async';

import 'package:flutter/foundation.dart';

FutureOr<String?> routerRedirections (context, state, dynamic streamProvider) async {
      //TODO: La mettre ailleur
      final userStreamProvider = streamProvider;
          // ref.read(authRepositoryProvider).authStateChange();
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
    }