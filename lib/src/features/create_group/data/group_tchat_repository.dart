// import 'dart:ffi';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/create_group/domain/group_tchat.dart';

class GroupTchatRepository {
  final FirebaseFirestore firestore;

  GroupTchatRepository({required this.firestore});


  ///Transforme la liste des utilisateurs récupérer de la base de données
  ///en une liste d'AppUser
  List<AppUser> _snapshotToAppUsersList(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    var userList = snapshot.docs.map((user) {
      var userProperties = user.data();
      userProperties['groupId'] = userProperties['groupId'].length == 0
          ? <String>[]
          : userProperties['groupId'];
      return {
        ...userProperties,
        ...{'uid': user.reference.id},
      };
    }).toList();
    return userList.map((e) => AppUser.fromMap(e)).toList();
  }

  ///TODO: Doit être agnostique (ne pas utiliser AppUser) c'est le controller qui doit faire le mapping
  Future<List<AppUser>> retrieveAllUsers() async {
    var snapshot = await firestore.collection('users').get();
    return Future.value(_snapshotToAppUsersList(snapshot));
  }

///Je ne passe pas de GroupTchat car le repository doit être agnostique
  Future<String> createGroupTchat(String ownerID, List<String> members ) async {
    final collection = firestore.collection('groups');
    final newTchat = GroupTchat(
      id: "temp",
      ownerId: ownerID,
      members: members,
      admins: [ownerID]
    );
    final item = await collection.add(newTchat.toMap(withId: false));
    return item.id;
  }
}

final GroupTchatRepositoryProvider = Provider<GroupTchatRepository>((ref) {
  return GroupTchatRepository(firestore: FirebaseFirestore.instance);
});

// final authRepositoryFirebaseStreamProvider = StreamProvider<User?>((ref) {
//   final authRepo = ref.watch(authRepositoryProvider);
//   return authRepo.authStateChange();
// });

// final authRepositoryUserStreamProvider = StreamProvider((ref) {
//   final authRepo = ref.watch(authRepositoryProvider);
//   return authRepo.userStreamController.stream; //userStream();
// });
