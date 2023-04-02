import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/create_group/data/group_tchat_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/create_group/presentation/create_group_state.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/localization/string_hardcoded.dart';

/*
 ! Le controller:
 - hold business logic
 - manage the widget state
 - interact with repositories in the data layer
*/

class CreateGroupController extends StateNotifier<CreateGroupState> {
  final GroupTchatRepository groupRepository;
  final AuthRepository authRepository;
  CreateGroupController(
      {required this.authRepository, required this.groupRepository})
      : super(CreateGroupState()) {
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
    final query = state.searchQuery;
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
      if (authRepository.currentUser == null) {
        final errorMessage =
            "Vous devez être connecté pour éffectuer cette opération".hardcoded;
        state =
            state.copyWith(value: AsyncError(errorMessage, StackTrace.current));
        return AsyncError(errorMessage, StackTrace.current);
      }
      final ownerID = authRepository.currentUser?.uid;
      final members = state.selectedUsers.map((member) => member.uid).toList();
      final groupId = await groupRepository.createGroupTchat(ownerID!, members);
      state = state.copyWith(value: const AsyncData(null));
      return AsyncData(groupId);
    } catch (err, st) {
      state = state.copyWith(value: AsyncError(err, st));
      return AsyncError(err, st);
    }
  }
}

final CreateGroupControllerProvider =
    StateNotifierProvider<CreateGroupController, CreateGroupState>((ref) {
  final GroupTchatRepository groupTchatRepo =
      ref.watch(GroupTchatRepositoryProvider);
  final AuthRepository authRepo = ref.watch(authRepositoryProvider);
  return CreateGroupController(
      authRepository: authRepo, groupRepository: groupTchatRepo);
});
