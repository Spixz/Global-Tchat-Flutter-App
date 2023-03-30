import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/presentation/account_app_bar/account_app_bar.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/presentation/account_controller.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/utils/async_value_ui.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeTestState();
}

class _HomeTestState extends ConsumerState<AccountScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();

  String get email => _emailController.text;
  String get username => _usernameController.text;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(accountControllerProvider, (previous, state) {
      state.value.showAlertDialogOnError(context);
    });

    var stream = ref.watch(authRepositoryUserStreamProvider);
    stream.whenData((user) => {
          _emailController.text = user?.email ?? '',
          _usernameController.text = user?.username ?? '',
        });

    return Scaffold(
        appBar: const AccountAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Username',
                  labelText: 'Name',
                ),
              ),
              TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Email',
                  labelText: 'Email',
                ),
              ),
              TextButton(
                  onPressed: () async {
                    await ref
                        .read(authRepositoryProvider)
                        .changeUserInformations({
                      'username': username,
                    });
                  },
                  child: const Text("Save")),
              TextButton(
                  onPressed: () async {
                    await ref
                        .read(accountControllerProvider.notifier)
                        .signOut();
                  },
                  child: const Text("Logout")),
            ],
          ),
        ));
  }
}
