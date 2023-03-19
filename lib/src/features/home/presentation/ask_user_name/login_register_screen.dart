import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/home/presentation/home_app_bar/home_app_bar.dart';

/// Shows the product page for a given product ID.
class AskUserNameScreen extends ConsumerWidget {
  const AskUserNameScreen({super.key});
  final users = const {
    'dribbble@gmail.com': '12345',
    'hunter@gmail.com': 'hunter',
  };

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: const HomeAppBar(),
        body: Consumer(builder: (context, ref, child) {
          //return const UsernamePrompt();
          return FlutterLogin(
              title: 'ECORP',
              //logo: AssetImage('assets/images/ecorp-lightblue.png'),
              onLogin: _authUser,
              onSignup: _signupUser,
              onSubmitAnimationCompleted: () {},
              onRecoverPassword: _recoverPassword,
              loginProviders: <LoginProvider>[
                LoginProvider(
                  icon: Icons.person_off,
                  label: "Se connecter en tant qu'invité",
                  callback: () async {
                    debugPrint('start google sign in');
                    await Future.delayed(loginTime);
                    debugPrint('stop google sign in');
                    return null;
                  },
                ),
              ]);
        }));
  }
}
