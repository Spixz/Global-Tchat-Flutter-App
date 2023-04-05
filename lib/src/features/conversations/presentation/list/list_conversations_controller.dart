import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/data/conversations_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/list/list_conversations_state.dart';

class ListConversationsController
    extends StateNotifier<ListConversationsState> {
  final ConversationsRepository groupRepository;
  final AuthRepository authRepository;
  ListConversationsController(
      {required this.authRepository, required this.groupRepository})
      : super(ListConversationsState(value: const AsyncLoading())) {
    //!  Le user est vide,
    //! Je pense que comme le controller est init une seule fois, je dois
    //! mettre un listen pour update le state du controller
    // * Se mettre en loading
    authRepository.userStream().listen((event) {
      print("Changement de user détecté dans par le listController");
      retrieveUserConversations(authRepository.currentUser!.uid);
      // * Ne plus se mettre en loading
    });
  }

//! Done
  Future<void> retrieveUserConversations(String userId) async {
    state = state.copyWith(value: const AsyncLoading());
    var val = await groupRepository.retrieveUserConversationsFilledWithMembers(
        authRepository.currentUser!.uid);
    print(val);
    state = state.copyWith(bindedConversations: val, value: AsyncData(val));
  }
}

final listConversationsControllerProvider =
    StateNotifierProvider<ListConversationsController, ListConversationsState>(
        (ref) {
  final ConversationsRepository groupTchatRepo =
      ref.watch(GroupTchatRepositoryProvider);
  final AuthRepository authRepo = ref.watch(authRepositoryProvider);
  // var streamm = ref.watch(authRepositoryUserStreamProvider);

  return ListConversationsController(
      authRepository: authRepo, groupRepository: groupTchatRepo);
});
