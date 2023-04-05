import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/common_widgets/empty_widget.dart';

class DisplayConversations extends ConsumerStatefulWidget {
  const DisplayConversations({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DisplayConversationsState();
}

class _DisplayConversationsState extends ConsumerState<DisplayConversations> {
  @override
  Widget build(BuildContext context) {
    // ref.listen(CreateConversationControllerProvider, (previous, state) {
    //   state.value.showAlertDialogOnError(context);
    // });

    // final state = ref.watch(CreateConversationControllerProvider);
    // final searchResults = state.searchResults;
    // final selectedUsers = state.selectedUsers;
    // print("BUILD");

    // return Scaffold(
    //     appBar: AppBar(title: const Text('Create New Group')),
    //     body: Column(
    //       // mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         TextFormField(
    //           decoration: const InputDecoration(
    //             icon: Icon(Icons.person),
    //             hintText: 'Username',
    //             labelText: 'Name',
    //           ),
    //           onChanged: (value) => updateQueryAndSearch(value),
    //         ),
    //         SelectedUsers(selectedUsers: selectedUsers),
    //         SearchResults(searchResult: searchResults)
    //       ],
    //     ),
    //     floatingActionButton: FloatingActionButton(
    //         onPressed: () => createGroupTchat(),
    //         backgroundColor: Colors.green,
    //         child: const Icon(Icons.arrow_forward)));
    return const EmptyWidget();
  }
}
