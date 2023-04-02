import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/create_group/presentation/create_group_controller.dart';

class SearchResults extends ConsumerStatefulWidget {
  final List<AppUser> searchResult;
  const SearchResults({super.key, required this.searchResult});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchResultState();
}

class _SearchResultState extends ConsumerState<SearchResults> {
  void _addUserToSelectedUsers(AppUser user) {
    ref
        .read(CreateGroupControllerProvider.notifier)
        .addUserToSelectedUsers(user);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.5,
      child: ListView.builder(
          itemCount: widget.searchResult.length,
          itemBuilder: (context, index) {
            final AppUser user = widget.searchResult[index];
            return ListTile(
              // key: UniqueKey(),
              leading: (user.profilePic.isNotEmpty)
                  ? CircleAvatar(backgroundImage: NetworkImage(user.profilePic))
                  : const Icon(Icons.person),
              title: Text(user.username),
              onTap: () {
                _addUserToSelectedUsers(user);
              },
            );
          }),
    );
  }
}
