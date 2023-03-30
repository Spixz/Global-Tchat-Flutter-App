import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/presentation/login_register_state.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/localization/string_hardcoded.dart';

/*
 ! Le controller:
 - hold business logic
 - manage the widget state
 - interact with repositories in the data layer
*/

class AuthController extends StateNotifier<AccountState> {
  final AuthRepository auth;
  AuthController({required this.auth}) : super(AccountState());

  Future<String?> signInWithUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final tmp = await auth.signInUserWithEmailAndPassword(email, password);
      print(tmp);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No user found for that email.".hardcoded;
      } else if (e.code == 'wrong-password') {
        return "Wrong password provided for that user.".hardcoded;
      }
    } catch (e) {
      return "Une erreur s'est produite durant la connection".hardcoded;
    }
    return null;
  }

  Future<String?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final tmp = await auth.createUserWithEmailAndPassword(email, password);
      print(tmp);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return "Une erreur s'est produite";
    }
    return null;
    // state = state.copyWith(value: const AsyncLoading());
    // final data = await AsyncValue.guard(
    //     () => auth.createUserWithEmailAndPassword(email, password));
    // state = state.copyWith(value: data);
    // return data;
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AccountState>((ref) {
  final AuthRepository auth = ref.watch(authRepositoryProvider);
  return AuthController(auth: auth);
});

/*
! En réalité, il n'y a pas besoin de state pck le widget login que j'utilise
* gère déjà l'affichage des erreurs. Le state m'aurait servis à gérer l'affichage
* des erreurs et le loading. Là il me suffit seulement de retourner une string
* si erreur il y.
*/