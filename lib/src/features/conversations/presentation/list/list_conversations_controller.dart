import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/data/conversations_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversationWithMembers.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/list/list_conversations_state.dart';

class ListConversationsController
    extends StateNotifier<ListConversationsState> {
  final ConversationsRepository groupRepository;
  final AuthRepository authRepository;
  final Ref ref;

  late StreamSubscription<AppUser?> userStreamSubscription;
  late StreamSubscription<List<ConversationWithMembers>>
      conversationStreamSubscription;
  late ProviderSubscription<AsyncValue<List<ConversationWithMembers>>> ps2;

  ListConversationsController(
      {required this.authRepository,
      required this.groupRepository,
      required this.ref})
      : super(ListConversationsState(value: const AsyncData(null))) {
    print("ListConversationsController est créé");
    _listenAuthStream();
  }

  @override
  void dispose() async {
    print("The ListConversationsController was deleted");
    await userStreamSubscription.cancel();
    await conversationStreamSubscription.cancel();
    final a = userStreamSubscription.isPaused;
    final c = conversationStreamSubscription.isPaused;
    print(
        "userStreamSubscription.cancel() => $a, conversationStreamSubscription.cancel() => $c");

    // ps2.close();

    super.dispose();
  }

  void _listenAuthStream() {
    userStreamSubscription = authRepository.userStream().listen((event) async {
      if (authRepository.currentUser != null) {
        state = state.copyWith(currentUserUid: authRepository.currentUser!.uid);
        retrieveUserConversation();
      } else {
        print(
            'user == null => on call dispose from ListConversationsController');
        dispose();
      }
    });
  }

  void retrieveUserConversation() {
    //! foncitonne car on écoute le stream directement depuis le provider
    conversationStreamSubscription =
        groupRepository.getUserConversationsInformationsInRealtime().listen(
      (event) {
        state = state.copyWith(value: const AsyncLoading());
        state = state.copyWith(
            conversationsWithUsersObjects: event, value: AsyncData(event));
      },
      onError: (err, st) async {
        print(err);
        print(st);
        print(
            "error from listConversationController.getUserConversationsInformationsInRealtime");
        // print(err);
        // state = state.copyWith(value: AsyncError(err, st));
      },
    );

    //* Test avec watch pour faire comme la seconde rép: Loading H24
    // ref
    //     .watch(
    //         conversationWithMembersStreamProvider2(authRepository.currentUser))
    //     .when(data: (data) {
    //   print("Le stream dans le controller a recu une infos");
    //   print(data);
    //   state = state.copyWith(
    //       conversationsWithUsersObjects: data, value: AsyncData(data));
    // }, error: (err, st) {
    //   print("error");
    //   print(err);
    //   state = state.copyWith(value: AsyncError(err, st));
    // }, loading: () {
    //   print("loading");
    // });

//! fonctionne car ont envoie l'id de l'user ce qui va reconstruire le stream
    // ps2 = ref.listen(
    //     conversationWithMembersStreamProvider2(authRepository.currentUser),
    //     (_, data) {
    //   data.when(data: (data) {
    //     print("Le stream dans le controller a recu une infos");
    //     print(data);
    //     state = state.copyWith(
    //         conversationsWithUsersObjects: data, value: AsyncData(data));
    //   }, error: (err, st) {
    //     print("error");
    //     // print(err);
    //     // state = state.copyWith(value: AsyncError(err, st));
    //   }, loading: () {
    //     print("loading");
    //   });
    // });

    //! Mettre une des 2 fonctions du haut pour que ca fonctionne.

//!ne fonctionne pas car une fois construit, conversationWithMembersStreamProvider
//!ne sera pas reconstruit après le changement d'utilisateur.
//!Il n'est en faite pas lier à conversationRepositoryProvider. Si j'ai envie
//!qu'il soit reconstruit, je dois utiliser autoDispose sauf que je ne peux exploiter
//!listen d'un streamProvider.autoDispose que dans un Provider. Nous sommes actuellement
//!dans un StateNotifier.
    // ref.listen(conversationWithMembersStreamProvider, (_, data) {
    //   data.when(data: (data) {
    //     print("Le stream dans le controller a recu une infos");
    //     print(data);
    //     state = state.copyWith(
    //         conversationsWithUsersObjects: data, value: AsyncData(data));
    //   }, error: (err, st) {
    //     print("error");
    //     print(err);
    //     state = state.copyWith(value: AsyncError(err, st));
    //   }, loading: () {
    //     print("loading");
    //   });
    // });
  }

  void deleteConversation(String conversationId) async {
    state = state.copyWith(value: const AsyncLoading());
    final data = await AsyncValue.guard(
        () => groupRepository.deleteConversation(conversationId));
    state = state.copyWith(value: data);
  }
}

final listConversationsControllerProvider = StateNotifierProvider.autoDispose<
    ListConversationsController, ListConversationsState>((ref) {
  final ConversationsRepository groupTchatRepo =
      ref.watch(conversationsRepositoryProvider);
  // final convStreamProvider = ref.watch(conversationWithMembersStreamProvider);
  final AuthRepository authRepo = ref.watch(authRepositoryProvider);
  // ref.keepAlive();

  return ListConversationsController(
      authRepository: authRepo, groupRepository: groupTchatRepo, ref: ref);
});
