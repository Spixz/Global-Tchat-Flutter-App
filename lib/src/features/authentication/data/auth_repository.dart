import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/data/app_user.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AppUser? _actualUser;

  AuthRepository({required this.auth, required this.firestore}) {
    authStateChange().listen((User? user) async {
      debugPrint("Changement d'état du stream");
      if (user != null) {
        _actualUser = AppUser(fbUser: user);
        await retrieveUserData();
        print(_actualUser);
      }
      //TODO: Ma méthode qui va avec le nom de l'user, aller chercher ses infos dans firestore.
    });
  }

  AppUser? get currentUser => _actualUser;

  Stream<User?> authStateChange() => auth.authStateChanges();

  Future<dynamic> signInUserWithEmailAndPassword(
      String email, String password) async {
    return await auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<dynamic> createUserWithEmailAndPassword(
      String email, String password) async {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> setUserData() async {
    print("san set");

    if (_actualUser != null) {
        print("_actual user = null");
      await firestore
          .collection('users')
          .doc(_actualUser?.fbUser?.uid)
          .set(_actualUser!.toMap());
    }
  }

  /// Récupère les données de l'utilisateur dans firestore
  Future<void> retrieveUserData() async {
    if (_actualUser != null) {
      var collec = firestore.collection('users');
      if (collec == null) {
        return;
      }
      var userData = await firestore
          .collection('users')
          .doc(_actualUser?.fbUser?.uid)
          .get();
      if (userData.data() != null) {
        _actualUser = AppUser.fromMap({
          ...userData.data()!,
          ...{'fbUser': _actualUser?.fbUser}
        });
      }
    }
  }

  Future<dynamic> signOut() async {
    throw Exception("Une erreur s'est produite durant le logout");
    return FirebaseAuth.instance.signOut();
  }

  //   Future<UserModel?> getCurrentUserData() async {
  //   var userData =
  //       await firestore.collection('users').doc(auth.currentUser?.uid).get();

  //   UserModel? user;
  //   if (userData.data() != null) {
  //     user = UserModel.fromMap(userData.data()!);
  //   }
  //   return user;
  // }

  //  await firestore.collection('users').doc(uid).set(user.toMap());
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance);
});

final authRepositoryStreamProvider = StreamProvider<User?>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChange();
});
