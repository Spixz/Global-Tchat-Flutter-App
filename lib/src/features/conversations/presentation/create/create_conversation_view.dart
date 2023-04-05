import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/create/create_conversation_controller.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/create/search_result_widget.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/create/selected_users_widget.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/utils/async_value_ui.dart';

class CreateNewConversation extends ConsumerStatefulWidget {
  const CreateNewConversation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewConversationState();
}

class _CreateNewConversationState extends ConsumerState<CreateNewConversation> {
  void updateQueryAndSearch(String query) {
    ref
        .read(CreateConversationControllerProvider.notifier)
        .updateSearchQuery(query);
    ref.read(CreateConversationControllerProvider.notifier).searchUser();
  }

  void createGroupTchat() async {
    final groupId = await ref
        .read(CreateConversationControllerProvider.notifier)
        .createGroupTchat();
    //L'erreur sera catch par le listener plus haut
    groupId.whenData((value) {
      print("GROUP ID: $value");
      print("Redirection vers la conversation");
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(CreateConversationControllerProvider, (previous, state) {
      state.value.showAlertDialogOnError(context);
    });

    final state = ref.watch(CreateConversationControllerProvider);
    final searchResults = state.searchResults;
    final selectedUsers = state.selectedUsers;
    print("BUILD");

    return Scaffold(
        appBar: AppBar(title: const Text('Create New Group')),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Username',
                labelText: 'Name',
              ),
              onChanged: (value) => updateQueryAndSearch(value),
            ),
            SelectedUsers(selectedUsers: selectedUsers),
            SearchResults(searchResult: searchResults)
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => createGroupTchat(),
            backgroundColor: Colors.green,
            child: const Icon(Icons.arrow_forward)));
  }
}
