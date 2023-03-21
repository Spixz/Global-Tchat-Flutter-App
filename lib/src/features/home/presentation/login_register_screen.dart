import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/controller/auth_controller.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/home/presentation/home_app_bar/home_app_bar.dart';

/// Shows the product page for a given product ID.
class AskUserNameScreen extends ConsumerStatefulWidget {
  const AskUserNameScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AskUserNameScreenState();
}

class _AskUserNameScreenState extends ConsumerState<AskUserNameScreen> {
  final users = const {
    'dribbble@gmail.com': '12345',
    'hunter@gmail.com': 'hunter',
  };

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    // ref.read(userProvider.notifier).changeUserName("Cyril");
    var regisProv = ref.watch(regiserUserProvider(
        EmailPass(email: data.name, password: data.password)));
    regisProv.when(
        data: (value) => print("value: $value"),
        error: (err, stack) => print("err: $err"),
        loading: () => print("loading"));
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    //TODO: call depuis le repos firebase
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    var myUser = ref.watch(userProvider);
    // var myUser = ref.watch(userProvider.notifier); => renvoie le StateNotifier
    print(myUser.toJson());

    return Scaffold(
        appBar: const HomeAppBar(),
        body: FlutterLogin(
            title: 'ECORP',
            //logo: AssetImage('assets/images/ecorp-lightblue.png'),
            onLogin: _authUser,
            onSignup: _signupUser,
            onSubmitAnimationCompleted: () {},
            onRecoverPassword: _recoverPassword,
            loginProviders: <LoginProvider>[
              LoginProvider(
                icon: Icons.person_off,
                label: "Se connecter en tant qu'invité ${myUser.uid}",
                callback: () async {
                  debugPrint('start google sign in');
                  await Future.delayed(loginTime);
                  debugPrint('stop google sign in');
                  return null;
                },
              ),
            ]));
  }
}
