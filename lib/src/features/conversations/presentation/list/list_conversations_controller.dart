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
  late ProviderSubscription<AsyncValue<List<ConversationWithMembers>>>
      conversationStreamSubscription;

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
    // conversationStreamSubscription.close();
    super.dispose();
  }

  void _listenAuthStream() {
    userStreamSubscription = authRepository.userStream().listen((event) async {
      if (authRepository.currentUser != null) {
        state = state.copyWith(currentUserUid: authRepository.currentUser!.uid);
        retrieveUserConversation();
      }
    });
  }

  void retrieveUserConversation() {
    //! foncitonne car on écoute le stream directement depuis le provider
    // conversationStreamSubscription =
    //     groupRepository.getUserConversationsInformationsInRealtime().listen(
    //   (event) {
    //     state = state.copyWith(value: const AsyncLoading());
    //     state = state.copyWith(
    //         conversationsWithUsersObjects: event, value: AsyncData(event));
    //   },
    //   onError: (err, st) {
    //     print("error");
    //     print(err);
    //     state = state.copyWith(value: AsyncError(err, st));
    //   },
    // );

//! fonctionne car ont envoie l'id de l'user ce qui va reconstruire le stream
    conversationStreamSubscription = ref.listen(
        conversationWithMembersStreamProvider2(authRepository.currentUser),
        (_, data) {
      data.when(data: (data) {
        print("Le stream dans le controller a recu une infos");
        print(data);
        state = state.copyWith(
            conversationsWithUsersObjects: data, value: AsyncData(data));
      }, error: (err, st) {
        print("error");
        print(err);
        state = state.copyWith(value: AsyncError(err, st));
      }, loading: () {
        print("loading");
      });
    });

    //! Mettre une des 2 fonctions du haut pour que ca fonctionne.

//!devrait fonctionner car ont va appeler autoDispose sur notre StreamProvider
    // ref.listen(conversationWithMembersStreamProvider2, (_, data) {
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
  ref.keepAlive();

  return ListConversationsController(
      authRepository: authRepo,
      groupRepository: groupTchatRepo,
      ref: ref);
});
