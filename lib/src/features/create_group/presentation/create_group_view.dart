import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/create_group/presentation/create_group_controller.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/create_group/presentation/search_result_widget.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/create_group/presentation/selected_users_widget.dart';

import '../../account/domain/app_user.dart';

class CreateNewGroup extends ConsumerStatefulWidget {
  const CreateNewGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateNewGroupState();
}

class _CreateNewGroupState extends ConsumerState<CreateNewGroup> {
  final _usernameController = TextEditingController(text: "");

  // final users = [
  //   "jack",
  //   "Paul",
  //   "Moran",
  //   "Pierre",
  //   "jackk",
  //   "jack124",
  //   "jAck",
  //   "Cyril"
  // ];
  // List<String> usersFound = [];
  // List<String> searchUser(String username) => //TODO remplacer par une future
  //     users.where((user) => user.toLowerCase().startsWith(username)).toList();

  final List<AppUser> usersFound = [];

  @override
  void initState() {
    // super.initState();
    // _usernameController.addListener(() {
    //   setState(() {
    //     usersFound.clear();
    //     if (_usernameController.text.isNotEmpty) {
    //       usersFound = searchUser(_usernameController.text);
    //       ref.read(accountControllerProvider.notifier).retrieveAllUsers();
    //     }
    //   });
    // });
  }

  void updateQueryAndSearch(String query) {
    ref.read(CreateGroupControllerProvider.notifier).updateSearchQuery(query);
    ref.read(CreateGroupControllerProvider.notifier).searchUser();
  }

  void createGroupTchat(ow) async {
    final groupId = await ref
        .read(CreateGroupControllerProvider.notifier)
        .createGroupTchat();
    //L'erreur sera catch par le listener plus haut
    groupId.whenData((value) {
      print("GROUP ID: $value");
      print("Redirection vers la conversation");
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(CreateGroupControllerProvider);
    final searchResults = state.searchResults;
    final selectedUsers = state.selectedUsers;
    print("BUILD");
    print(searchResults);

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
            onPressed: () async {
              createGroupTchat(context);
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.arrow_forward)));
  }
}
