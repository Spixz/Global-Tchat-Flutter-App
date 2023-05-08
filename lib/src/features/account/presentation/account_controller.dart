import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/common_repositories/firebase_storage_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/common_repositories/firestore_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/presentation/account_state.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/localization/string_hardcoded.dart';

/*
 ! Le controller:
 - hold business logic
 - manage the widget state
 - interact with repositories in the data layer
*/

class AccountController extends StateNotifier<AccountState> {
  final AuthRepository auth;
  final FirebaseStorageRepository firebase;
  final FirestoreRepository firestore;

  AccountController(
      {required this.auth, required this.firebase, required this.firestore})
      : super(AccountState(value: const AsyncValue.data(null))) {
    //modification du state car le listen ne vas pas récupérer les derniers éléments émis.
    state = state.copyWith(user: auth.currentUser);
    _listenAuthStream();
  }

  /// Le wiget va être rebuild seuleument si le state du state notifier est modifié.
  /// (c'est pour ça que je délcare un nouveau state à chaque fois.)
  /// Dans le conscturcteur, j'assigne la valeur de current user au state directement
  /// car listen ne récupère pas le dernier élément émis du stream.
  /// Listen servira plus tard quand quand la valeur de currentUser sera modifiée.
  /// Listen me prévient que currentUser à été modifié (déconnection ou ajout d'informations)
  /// ce qui me permet de mettre à jour mon state avec la nouvelle valeur.
  void _listenAuthStream() {
    auth.userStream().listen((event) async {
      print(
          "Le controller de account à été notifié d'une modif du stream auth.userStream");
      if (auth.currentUser != null) {
        print("le state de account a été modifié avec la valeur suivante");
        print(auth.currentUser);
        state = state.copyWith(user: auth.currentUser);
        // retrieveUserConversation();
      }
    });
  }

  Stream<AppUser?> get userStream => auth.userStream();

  void sendFile(String fileDest, Uint8List? uint8list) async {
    state = state.copyWith(value: const AsyncLoading());
    AsyncValue value = await AsyncValue.guard(() async {
      final link = await firebase.uploadFile(fileDest, uint8list);
      await firestore.updateDocument('users', auth.currentUser!.uid, {
        'profilePic': link,
      });
    });
    state = state.copyWith(
        value: value.hasValue
            ? AsyncData("Photo de profil modifiée avec succès".hardcoded)
            : value);
  }

  Future<dynamic> signOut() async {
    state = state.copyWith(value: const AsyncLoading());
    final data = await AsyncValue.guard(() => auth.signOut());
    state = state.copyWith(value: data);
  }

  Future<dynamic> changeUserInformations(Map<String, dynamic> datas) async {
    state = state.copyWith(value: const AsyncLoading());
    AsyncValue data =
        await AsyncValue.guard(() => auth.changeUserInformations(datas));
    state = state.copyWith(
        value: data.hasValue
            ? const AsyncData("Modifications enregistrées")
            : data);
  }
}

final accountControllerProvider =
    StateNotifierProvider<AccountController, AccountState>((ref) {
  final AuthRepository auth = ref.watch(authRepositoryProvider);
  final FirebaseStorageRepository firebase =
      ref.watch(firebaseStorageRepositoryProvider);
  final FirestoreRepository firestore = ref.watch(firestoreRepositoryProvider);
  return AccountController(
      auth: auth, firebase: firebase, firestore: firestore);
});
