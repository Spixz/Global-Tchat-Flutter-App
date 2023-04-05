import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/list/conversation_tile_widet.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/list/list_conversations_controller.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/app_router.dart';

class ListConversations extends ConsumerStatefulWidget {
  const ListConversations({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListConversationsState();
}

class _ListConversationsState extends ConsumerState<ListConversations> {
  @override
  Widget build(BuildContext context) {
    // ref.listen(CreateConversationControllerProvider, (previous, state) {
    //   state.value.showAlertDialogOnError(context);
    // });

    final state = ref.watch(listConversationsControllerProvider);
    // final searchResults = state.searchResults;
    // final selectedUsers = state.selectedUsers;
    // print("BUILD");

    return Scaffold(
        appBar: AppBar(title: const Text('Conversations')),
        body: ListView.builder(
            itemCount: state.bindedConversations.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => print("Go to convresation"),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ConversationTile(
                      actualUserUid:
                          ref.read(authRepositoryProvider).currentUser!.uid,
                      conversation: state.bindedConversations[index]),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () => GoRouter.of(context)
                .pushNamed(AppRoute.createConversation.name),
            backgroundColor: Colors.green,
            child: const Icon(Icons.add)));
  }
}
