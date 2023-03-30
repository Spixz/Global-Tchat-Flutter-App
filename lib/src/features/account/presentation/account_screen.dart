import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/data/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/presentation/account_app_bar/account_app_bar.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/presentation/account_controller.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';

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
      // state.showAlertDialogOnError(context);
      if (state.value.hasError) {
        print("Erreur durant LOGOUT");
      }
    });

    AppUser? user = ref.watch(authRepositoryProvider).currentUser;
    if (user != null) {
      // debugPrint(user.toJson());
      // debugPrint(user.fbUser!.email);
      _emailController.text = user.fbUser?.email ?? "";
      _usernameController.text = user.username ?? "none";
    }

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
                  labelText: 'Name *',
                ),
                onSaved: (String? value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                // validator: (String? value) {
                //   return (value != null && value.contains('@'))
                //       ? 'Do not use the @ char.'
                //       : null;
                // },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Email',
                  labelText: 'Email',
                ),
              ),
              TextButton(
                  onPressed: () async {
                    user?.username = _usernameController.text;
                    await ref.read(authRepositoryProvider).setUserData();
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
