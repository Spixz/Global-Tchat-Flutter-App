import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/fake_auth_repository.dart';

// class AuthController {
//   AuthController({
//     required this.authRepository,
//     required this.userRepository,
//   });
//   final AuthRepository authRepository; //frebase
//   final AppUser userRepository;

//   void registerUser(String email, String password) {
//     authRepository.createUserWithEmailAndPassword(email, password);
//   }
// }

// final AuthControllerProvider = Provider<AuthController>((ref) {
//   return AuthController(ref.watch(userRepositoryProvider));
// });

final regiserUserProvider =
    FutureProvider.family<dynamic, EmailPass>((ref, data) {
  print("1");
  final athr = ref.watch(authRepositoryProvider);
  // final usr = ref.read(userProvider.notifier);
  print("2");
  try {
    print("tentarive refister");
    print(athr.createUserWithEmailAndPassword(data.email, data.password));
  } catch (err) {
    print("erreur durant le register sur firebase: $err");
  }
  // usr.changeUserName(data.email);
  return Future.value(32);
});

class EmailPass {
  final String email;
  final String password;
  EmailPass({required this.email, required this.password});
}
