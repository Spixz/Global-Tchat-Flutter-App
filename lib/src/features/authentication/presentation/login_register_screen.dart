import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/constants/colors.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/presentation/login_register_controller.dart';

/// Shows the product page for a given product ID.
class LoginRegisterScreen extends ConsumerStatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends ConsumerState<LoginRegisterScreen> {
  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return ref
        .read(authControllerProvider.notifier)
        .signInWithUserWithEmailAndPassword(data.name, data.password);
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return ref
        .read(authControllerProvider.notifier)
        .createUserWithEmailAndPassword(data.name!, data.password!);
  }

  Future<String?> _recoverPassword(String name) {
    return Future(() => null);
    // debugPrint('Name: $name');
    // return Future.delayed(loginTime).then((_) {
    //   if (!users.containsKey(name)) {
    //     return 'User not exists';
    //   }
    //   return null;
    // });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        // appBar: const LoginRegisterAppBar(),
        body: FlutterLogin(
      title: 'GlobalTchat',
      // logo: const AssetImage('assets/images/ecorp-lightblue.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {},
      onRecoverPassword: _recoverPassword,
      theme: LoginTheme(
        pageColorLight: loginPageColor,
        primaryColor: loginPrimaryColor,
      ),
      // loginProviders: <LoginProvider>[
      //   LoginProvider(
      //     icon: Icons.person_off,
      //     label: "Se connecter en tant qu'invité",
      //     callback: () async {
      //       debugPrint('start google sign in');
      //       await Future.delayed(loginTime);
      //       debugPrint('stop google sign in');
      //       return null;
      //     },
      //   ),
      // ]
    ));
  }
}
