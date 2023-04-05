// import 'dart:ffi';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversation.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversationBinded.dart';

class ConversationsRepository {
  final FirebaseFirestore firestore;

  ConversationsRepository({required this.firestore});

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
    // var collectionRef = firestore.collection('users');
    // final dernierElementSnapshot = await collectionRef
    //     .orderBy(FieldPath.documentId, descending: true)
    //     .limit(1)
    //     .get();
    // final dernierElementData = dernierElementSnapshot.docs.first.data();
    // print('single unit');
    // print(dernierElementData);
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

  Future<List<Conversation>> retrieveUserConversations(String userId) async {
    var groupsRef = firestore.collection('groups');
    var snapshot =
        await groupsRef.where("members", arrayContains: userId).get();
    return snapshot.docs.map((data) {
      var conversation = data.data();
      conversation['id'] = data.reference.id;
      return Conversation.fromMap(conversation);
    }).toList();
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

  Future<List<ConversationWithMembers>>
      retrieveUserConversationsFilledWithMembers(String userId) async {
    var groupsRef = firestore.collection('groups');
    var snapshot =
        await groupsRef.where("members", arrayContains: userId).get();
    var res = await Future.wait(snapshot.docs.map((data) async {
      var conversation = data.data();
      conversation['id'] = data.reference.id;
      Conversation conv = Conversation.fromMap(conversation);
      List<AppUser> members = await retrieveUsersFromList(conv.members);
      return ConversationWithMembers(conv, members);
    }).toList());
    return res;
  }
}

final GroupTchatRepositoryProvider = Provider<ConversationsRepository>((ref) {
  return ConversationsRepository(firestore: FirebaseFirestore.instance);
});
