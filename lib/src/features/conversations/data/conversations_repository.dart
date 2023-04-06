// import 'dart:ffi';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversation.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversationBinded.dart';

class ConversationsRepository {
  final FirebaseFirestore firestore;
  final AuthRepository auth;

  ConversationsRepository({required this.auth, required this.firestore});

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

//TODO: demander sur le slack si je peux dépendndre d'un autre repository
//TODO: Ou si je dois mettre la logique qui supprimer l'user concerné dans un controller.
  Future<List<AppUser>> retrieveAllUsers() async {
    var snapshot = await firestore.collection('users').get();
    return Future.value(_snapshotToAppUsersList(snapshot));
  }

  ///Je ne passe pas de GroupTchat car le repository doit être agnostique
  Future<String> createGroupTchat(String ownerID, List<String> members) async {
    final collection = firestore.collection('groups');
    final newTchat = Conversation(
        id: '', ownerId: ownerID, members: members, admins: [ownerID]);
    final item = await collection.add(newTchat.toMap(withId: false));
    return item.id;
  }


  Future<List<AppUser>> retrieveUsersFromList(List<String> uids) async {
    var usersRef = firestore.collection('users');
    var snapshot =
        await usersRef.where(FieldPath.documentId, whereIn: uids).get();
    return snapshot.docs.map((data) {
      var user = data.data();
      user['uid'] = data.reference.id;
      return AppUser.fromMap(user);
    }).toList();
  }

  Stream<List<ConversationWithMembers>> getConversationInRealtime() {
    return firestore
        .collection('groups')
        .where('members', arrayContains: auth.currentUser!.uid)
        .snapshots()
        .asyncMap((event) async {
      List<ConversationWithMembers> newConversations = [];
      for (var document in event.docs) {
        var conversation = document.data();
        conversation['id'] = document.reference.id;
        Conversation conv = Conversation.fromMap(conversation);
        List<AppUser> members = await retrieveUsersFromList(conv.members);
        newConversations.add(ConversationWithMembers(conv, members));
      }
      return newConversations;
    });
  }
}

final GroupTchatRepositoryProvider = Provider<ConversationsRepository>((ref) {
  final AuthRepository auth = ref.watch(authRepositoryProvider);
  return ConversationsRepository(
      auth: auth, firestore: FirebaseFirestore.instance);
});
