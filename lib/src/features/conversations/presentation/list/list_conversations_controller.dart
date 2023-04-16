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
      : super(ListConversationsState(value: const AsyncData(null))) {
    _listenAuthStream();
  }

  void _listenAuthStream() {
    authRepository.userStream().listen((event) async {
      if (authRepository.currentUser != null) {
        state = state.copyWith(currentUserUid: authRepository.currentUser!.uid);
        retrieveUserConversation();
      }
    });
  }

  ///Todo: je dois fakes les données qui viennent du stream encore une fois
  void retrieveUserConversation() {
    groupRepository.getUserConversationsInformationsInRealtime().listen(
      (event) {
        state = state.copyWith(value: const AsyncLoading());
        state = state.copyWith(
            conversationsWithUsersObjects: event, value: AsyncData(event));
      },
      onError: (err, st) {
        state = state.copyWith(value: AsyncError(err, st));
      },
    );
  }
}

final listConversationsControllerProvider = StateNotifierProvider.autoDispose<
    ListConversationsController, ListConversationsState>((ref) {
  final ConversationsRepository groupTchatRepo =
      ref.watch(conversationsRepositoryProvider);
  final AuthRepository authRepo = ref.watch(authRepositoryProvider);

  return ListConversationsController(
      authRepository: authRepo, groupRepository: groupTchatRepo);
});
