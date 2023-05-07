import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/common_widgets/app_bar_menu.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/create/create_conversation_controller.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/create/search_bar_widget.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/create/search_result_widget.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/create/selected_users_widget.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/localization/string_hardcoded.dart';
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
      GoRouter.of(context).pop();
    });
  }

  void showGroupNameDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Group Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Optional'.hardcoded,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'.hardcoded),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Validate'.hardcoded),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ref
                      .read(CreateConversationControllerProvider.notifier)
                      .updateConversationName(controller.text);
                }
                controller.dispose();
                Navigator.of(context).pop();
                createGroupTchat();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(CreateConversationControllerProvider, (previous, state) {
      state.value.showAlertDialogOnError(context);
    });

    final state = ref.watch(CreateConversationControllerProvider);
    final searchResults = state.searchResults;
    final selectedUsers = state.selectedUsers;

    return Scaffold(
        appBar:
            AppBarMenu(title: 'Create New Group'.hardcoded, menuEnabled: false),
        body: Column(
          children: [
            SearchBar(updateQueryAndSearch: updateQueryAndSearch),
            SelectedUsers(selectedUsers: selectedUsers),
            SearchResults(searchResult: searchResults)
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => showGroupNameDialog(context), //createGroupTchat(),
            backgroundColor: Colors.green,
            child: const Icon(Icons.arrow_forward)));
  }
}
