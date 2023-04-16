import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/data/conversations_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/create_group_state.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/localization/string_hardcoded.dart';

/*
 ! Le controller:
 - hold business logic
 - manage the widget state
 - interact with repositories in the data layer
*/

class CreateConversationController
    extends StateNotifier<ListConversationsState> {
  final ConversationsRepository groupRepository;
  final AuthRepository authRepository;
  CreateConversationController(
      {required this.authRepository, required this.groupRepository})
      : super(ListConversationsState()) {
    retrieveAllUsers();
  }

  Future<void> retrieveAllUsers() async {
    state = state.copyWith(value: const AsyncLoading());
    var val = await groupRepository.retrieveAllUsers();
    state = state.copyWith(allUsersList: val, value: AsyncData(val));
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(value: const AsyncLoading());
    state = state.copyWith(searchQuery: query);
    state = state.copyWith(value: const AsyncData(null));
  }

  void searchUser() {
    state = state.copyWith(value: const AsyncLoading());
    final query = state.searchQuery.toLowerCase();
    final searchResult = state.allUsersList
        .where((user) => user.username.toLowerCase().startsWith(query))
        .toList();
    state = state.copyWith(
        searchResults: searchResult, value: const AsyncData(null));
  }

  void addUserToSelectedUsers(AppUser user) {
    if (state.selectedUsers.contains(user)) return;
    state = state.copyWith(value: const AsyncLoading());
    final updatedSelectedUsers = [
      user,
      ...state.selectedUsers,
    ];
    state = state.copyWith(
        selectedUsers: updatedSelectedUsers, value: const AsyncData(null));
  }

  void removeUserFromSelectedUsers(AppUser user) {
    state = state.copyWith(value: const AsyncLoading());
    final updatedSelectedUsers = state.selectedUsers
        .where((selectedUser) => selectedUser != user)
        .toList();
    state = state.copyWith(
        selectedUsers: updatedSelectedUsers, value: const AsyncData(null));
  }

  Future<AsyncValue<String>> createGroupTchat() async {
    state = state.copyWith(value: const AsyncLoading());
    try {
      ///En vrai inutile car le router check avant de load la page.
      if (authRepository.currentUser == null) {
        final errorMessage =
            "Vous devez être connecté pour éffectuer cette opération".hardcoded;
        state =
            state.copyWith(value: AsyncError(errorMessage, StackTrace.current));
        return AsyncError(errorMessage, StackTrace.current);
      }
      final ownerID = authRepository.currentUser?.uid;
      final members = [
        ...state.selectedUsers.map((member) => member.uid).toList(),
        ownerID!
      ];
      final groupId = await groupRepository.createGroupTchat(ownerID, members);
      state = state.copyWith(value: const AsyncData(null));
      return AsyncData(groupId);
    } catch (err, st) {
      state = state.copyWith(value: AsyncError(err, st));
      return AsyncError(err, st);
    }
  }

  //si imageUrl == null alors afficher l'image de l'autre user
  //sinon si c un grp, retourner null et afficher une image de groupe
}

final CreateConversationControllerProvider =
    StateNotifierProvider<CreateConversationController, ListConversationsState>(
        (ref) {
  final ConversationsRepository groupTchatRepo =
      ref.watch(conversationsRepositoryProvider);
  final AuthRepository authRepo = ref.watch(authRepositoryProvider);
  return CreateConversationController(
      authRepository: authRepo, groupRepository: groupTchatRepo);
});
