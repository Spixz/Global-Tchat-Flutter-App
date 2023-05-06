import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/create/create_conversation_controller.dart';

class SelectedUsers extends ConsumerStatefulWidget {
  final List<AppUser> selectedUsers;
  const SelectedUsers({super.key, required this.selectedUsers});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchResultState();
}

class _SearchResultState extends ConsumerState<SelectedUsers> {
  void removeUserFromSelectedUsers(AppUser user) {
    ref
        .read(CreateConversationControllerProvider.notifier)
        .removeUserFromSelectedUsers(user);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 15.0),
        // height: size.height * 0.3,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          // reverse: true,
          child: Row(
            children: List<Widget>.generate(
              widget.selectedUsers.length,
              (int index) {
                final AppUser user = widget.selectedUsers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InputChip(
                    label: Text(user.username),
                    onDeleted: () => removeUserFromSelectedUsers(user),
                  ),
                );
              },
            ).toList(),
          ),
        ));
  }
}
