import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/common_widgets/app_bar_menu.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/common_widgets/empty_widget.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/common_widgets/loading_widget.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/constants/colors.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/list/conversation_tile_widget.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/list/list_conversations_controller.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/list/long_press_popup_widget.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/localization/string_hardcoded.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/routing/app_router.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/utils/async_value_ui.dart';

class ListConversations extends ConsumerStatefulWidget {
  const ListConversations({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListConversationsState();
}

class _ListConversationsState extends ConsumerState<ListConversations> {
  void deleteConversation(String conversationId) {
    ref
        .read(listConversationsControllerProvider.notifier)
        .deleteConversation(conversationId);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(listConversationsControllerProvider, (previous, state) {
      state.value.showAlertDialogOnError(context);
    });

    final state = ref.watch(listConversationsControllerProvider);

    return Scaffold(
        appBar: AppBarMenu(title: 'GlobalTchat'.hardcoded),
        body: state.value.when(
            data: (data) => (state.conversationsWithUsersObjects.isNotEmpty)
                ? ListView.builder(
                    itemCount: state.conversationsWithUsersObjects.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        key: ValueKey(state.conversationsWithUsersObjects[index]
                            .hashCodeParent),
                        onTap: () => GoRouter.of(context).pushNamed(
                            AppRoute.displayConversation.name,
                            params: {
                              'id':
                                  state.conversationsWithUsersObjects[index].id
                            }),
                        onLongPress: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => ConversationPopup(
                              conversationId:
                                  state.conversationsWithUsersObjects[index].id,
                              deleteConversation: deleteConversation),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ConversationTile(
                              actualUserUid: state.currentUserUid,
                              conversation:
                                  state.conversationsWithUsersObjects[index]),
                        ),
                      );
                    })
                : Center(child: Text("No conversations yet".hardcoded)),
            error: (err, st) => const EmptyWidget(),
            loading: () => const LoadingWidget()),
        floatingActionButton: FloatingActionButton(
            onPressed: () => GoRouter.of(context)
                .pushNamed(AppRoute.createConversation.name),
            backgroundColor: floatingButtonColor,
            child: const Icon(Icons.add)));
  }
}