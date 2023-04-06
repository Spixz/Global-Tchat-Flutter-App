import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/common_widgets/empty_widget.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/common_widgets/loading_widget.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/list/conversation_tile_widet.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/list/list_conversations_controller.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/app_router.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/utils/async_value_ui.dart';

class ListConversations extends ConsumerStatefulWidget {
  const ListConversations({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListConversationsState();
}

class _ListConversationsState extends ConsumerState<ListConversations> {
  @override
  Widget build(BuildContext context) {
    ref.listen(listConversationsControllerProvider, (previous, state) {
      state.value.showAlertDialogOnError(context);
    });

    final state = ref.watch(listConversationsControllerProvider);

    return Scaffold(
        appBar: AppBar(title: const Text('Conversations')),
        body: state.value.when(
            data: (data) => ListView.builder(
                itemCount: state.bindedConversations.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => print("Go to convresation"),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ConversationTile(
                          actualUserUid: state.currentUserUid,
                          conversation: state.bindedConversations[index]),
                    ),
                  );
                }),
            error: (err, st) => const EmptyWidget(),
            loading: () => const LoadingWidget()),
        floatingActionButton: FloatingActionButton(
            onPressed: () => GoRouter.of(context)
                .pushNamed(AppRoute.createConversation.name),
            backgroundColor: Colors.green,
            child: const Icon(Icons.add)));
  }
}
