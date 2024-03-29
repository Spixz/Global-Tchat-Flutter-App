// import 'dart:ffi';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  StreamSubscription? userInfosModificationsListener;
  AppUser? _actualUser;

  /// Modifie le _actualUser si un utilisateur se connecte ou déconnecte (from firebase stream)
  /// + Si une modification a lieu dans les données de l'user connecté, alors
  /// un nouveau _actualUser avec les données mises à jour est émis.
  AuthRepository(
      {required this.auth,
      required this.firestore,
      this.userInfosModificationsListener}) {
    authStateChange().listen((User? user) async {
      debugPrint("Firebase auth modification");
      _actualUser = (user != null) ? await retrieveUserFromUid(user.uid) : null;
      userStreamController.add(_actualUser);
      if (user != null) {
        userInfosModificationsListener = firestore
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((event) async {
          var newUser = event.data();
          // if (newUser == null) {
          //   return;
          // }
          newUser!['uid'] = user.uid;
          newUser['groupId'] =
              newUser['groupId'].length == 0 ? <String>[] : newUser['groupId'];
          _actualUser = AppUser.fromMap(newUser);
          userStreamController.add(_actualUser);
        });
      } else {
        if (userInfosModificationsListener != null) {
          userInfosModificationsListener!.cancel();
        }
      }
    });
  }

  AppUser? get currentUser => _actualUser;

  Stream<User?> authStateChange() =>
      auth.authStateChanges(); //Stream de firebase
  StreamController<AppUser?> userStreamController =
      StreamController<AppUser?>.broadcast();
  //Stream écoutant le stream Auth de firebase et émettant son propre event
  //pour uddate la route de goRouter. J'ai du arrêter d'utiliser le stream de firebase
  //car je l'écoutais puis faisais des modifications sur _actualUser. Or c'est modifications
  //survenaient après l'émission de l'event et donc goRouter n'avait pas accès à
  //la valeur de _actualUser mise à jour.
  //https://medium.com/flutter-community/flutter-stream-basics-for-beginners-eda23e44e32f

  Stream<AppUser?> userStream() => userStreamController.stream;

  Future<dynamic> signInUserWithEmailAndPassword(
      String email, String password) async {
    return await auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<dynamic> signOut() async {
    // throw Exception("Une erreur s'est produite durant le logout");
    return FirebaseAuth.instance.signOut();
  }

  Future<dynamic> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential credentials =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credentials.user != null) {
      User? fbUser = credentials.user;
      _actualUser = AppUser(
          uid: fbUser!.uid,
          email: fbUser.email ?? "",
          username: "",
          profilePic: "",
          isOnline: false,
          groupId: []);
      await saveUserInformations();
    }
  }

  Future<void> changeUserInformations(Map<String, dynamic> datas) async {
    datas.removeWhere((key, value) => !AppUser.properties.contains(key));
    if (_actualUser != null) {
      _actualUser = _actualUser?.copyWithFromMap(datas);
      userStreamController.add(_actualUser);
      await firestore.collection('users').doc(_actualUser!.uid).update(datas);
    }
  }

  Future<void> saveUserInformations() async {
    if (_actualUser != null) {
      await firestore
          .collection('users')
          .doc(_actualUser!.uid)
          .set(_actualUser!.toMap(withUid: false));
      userStreamController.add(_actualUser);
    }
  }

  Future<AppUser?> retrieveUserFromUid(String uid) async {
    var req = await firestore.collection('users').doc(uid).get();
    var userData = req.data();
    if (userData != null) {
      userData['uid'] = uid;
      userData['groupId'] =
          userData['groupId'].length == 0 ? <String>[] : userData['groupId'];
      return AppUser.fromMap(userData);
    }
    return null;
  }

  final authRepositoryUserStreamProvider =
      StreamProvider((ref) => ref.watch(authRepositoryProvider).userStream());
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance);
});

// final authRepositoryFirebaseStreamProvider = StreamProvider<User?>((ref) {
//   final authRepo = ref.watch(authRepositoryProvider);
//   return authRepo.authStateChange();
// });

final authRepositoryUserStreamProvider =
    StreamProvider((ref) => ref.watch(authRepositoryProvider).userStream());
