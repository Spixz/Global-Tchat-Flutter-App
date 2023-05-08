// import 'dart:ffi';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversation.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversationWithMembers.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/message.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/message_collection.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ConversationsRepository {
  final FirebaseFirestore firestore;
  final AuthRepository auth;
  final FirebaseStorage storage;

  // StreamController<List<ConversationWithMembers>> conversationStreamController =
  //     StreamController<List<ConversationWithMembers>>.broadcast();
  // Stream<List<ConversationWithMembers>>
  //     getUserConversationsInformationsInRealtime() =>
  //         conversationStreamController.stream;

  ConversationsRepository(
      {required this.auth, required this.firestore, required this.storage}) {
    // initConversationStreamController();
  }

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
  Future<String> createGroupTchat(
      String? conversationName, String ownerID, List<String> members) async {
    final conversationCollection = firestore.collection('groups');
    final messageCollection = firestore.collection('messages');
    final newTchat = Conversation(
        id: '',
        name: conversationName,
        ownerId: ownerID,
        members: members,
        admins: [ownerID],
        lastMessageTimeSent: DateTime.fromMicrosecondsSinceEpoch(0));
    final group =
        await conversationCollection.add(newTchat.toMap(withId: false));
    await messageCollection.doc(group.id).set({
      'messages': [],
    });
    return group.id;
  }

//TODO: Doit supprimer aussi les médias lié à la conversation
  Future deleteConversation(String conversationId) async {
    final conversationCollection = firestore.collection('groups');
    final messageCollection = firestore.collection('messages');
    await conversationCollection.doc(conversationId).delete();
    await messageCollection.doc(conversationId).delete();
  }

  Future<List<AppUser>> retrieveUsersObjectFromList(List<String> uids) async {
    var usersRef = firestore.collection('users');
    var snapshot =
        await usersRef.where(FieldPath.documentId, whereIn: uids).get();
    return snapshot.docs.map((data) {
      var user = data.data();
      user['uid'] = data.reference.id;
      return AppUser.fromMap(user);
    }).toList();
  }

//Stream émettant les informations des conversations dans lesquels l'user
//est présent.
//En vrai c'est utile pour refresh la page des conversations pour savoir si un
//new message a été ajouté.
  Stream<List<ConversationWithMembers>>
      getUserConversationsInformationsInRealtime() {
    print("Init du stream getUserConversationsInformationsInRealtime");
    // print(auth.currentUser);
    if (auth.currentUser == null) {
      return const Stream.empty();
    }
    return firestore
        .collection('groups')
        .where('members', arrayContains: auth.currentUser!.uid)
        .snapshots()
        .asyncMap((event) async {
      print("Emission convresations");
      List<ConversationWithMembers> newConversations = [];
      for (var document in event.docs) {
        var conversation = document.data();
        conversation['id'] = document.reference.id;
        Conversation conv = Conversation.fromMap(conversation);
        List<AppUser> members = await retrieveUsersObjectFromList(conv.members);
        newConversations.add(ConversationWithMembers(conv, members));
      }
      return newConversations;
    });
  }

  Stream<List<ConversationWithMembers>>
      getUserConversationsInformationsInRealtime2(AppUser? user) {
    print("Init du stream getUserConversationsInformationsInRealtime2");
    print(user);
    if (user == null) {
      return const Stream.empty();
    }
    print("l'init continue");
    return firestore
        .collection('groups')
        .where('members', arrayContains: user.uid)
        .snapshots()
        .asyncMap((event) async {
      List<ConversationWithMembers> newConversations = [];
      for (var document in event.docs) {
        var conversation = document.data();
        conversation['id'] = document.reference.id;
        Conversation conv = Conversation.fromMap(conversation);
        List<AppUser> members = await retrieveUsersObjectFromList(conv.members);
        newConversations.add(ConversationWithMembers(conv, members));
      }
      print("Conv emise:");
      print(newConversations);
      return newConversations;
    });
  }

  // void initConversationStreamController() {
  //   firestore
  //       .collection('groups')
  //       .where('members', arrayContains: auth.currentUser!.uid)
  //       .snapshots()
  //       .asyncMap((event) async {
  //     List<ConversationWithMembers> newConversations = [];
  //     for (var document in event.docs) {
  //       var conversation = document.data();
  //       conversation['id'] = document.reference.id;
  //       Conversation conv = Conversation.fromMap(conversation);
  //       List<AppUser> members = await retrieveUsersObjectFromList(conv.members);
  //       newConversations.add(ConversationWithMembers(conv, members));
  //     }
  //     return newConversations;
  //   }).listen((event) {
  //     conversationStreamController.add(event);
  //   });
  // }

//En vrai c'est bien comme ça on récupé les messages que quand ont est dans la conv (le screen)
//Ca veut dire que les docs ne seront récup que si on est sur le screen de la conv.
//Pour opti, ont pourrai garder en mémoire la date de la dernière lecture de ce stream
//et ne récupérer que les messages supérieur à cette date.
  Stream<MessageCollection> getMessagesFromConversationInRealtime(
      String convId) {
    final snapshot = firestore
        .collection('messages')
        .where(FieldPath.documentId, isEqualTo: convId)
        .snapshots();
    return snapshot.asyncMap((event) {
      debugPrint("Mouvement dans les messages");
      var document = event.docs.first;
      var messages = document.data();
      messages['id'] = document.reference.id;
      return MessageCollection.fromMap(messages);
    });
  }

/* Dans la plutpart des cas je voudrais ajouter un message du coup
il vaut mieux appeller la méthode qui ajouter le message en priorité car ça sera
moins chère que de call la qui créer le doc à chaques fois.
*/
  Future<void> sendMessage(String conversationId, Message message) async {
    final collection = firestore.collection('messages');
    try {
      await collection.doc(conversationId).update({
        'messages': FieldValue.arrayUnion([message.toMap()])
      });
      debugPrint("Repo: Nouveau message ajouté avec succès");
    } catch (err) {
      debugPrint("Le doc Message corespondant n'existant pas, il a été créer.");
      await collection.doc(conversationId).set({
        'messages': [message.toMap()]
      });
    }
    await firestore.collection('groups').doc(conversationId).update({
      'lastMessage': message.content,
      'lastMessageSender': message.senderId,
      'lastMessageType': message.type.toString(),
      'lastMessageTimeSent': Timestamp.fromDate(message.createdAt),
    });
  }

  Future<void> changeMessageStatus(
      String conversationId, String messageId, bool status) async {
    final document = firestore.collection('messages').doc(conversationId);
    final snapshot = await document.get();
    List<dynamic> dynamicList = snapshot.data()?['messages'];
    List<Message> messages =
        dynamicList.map((e) => Message.fromMap(e)).toList();

    final int messageIndex =
        messages.indexWhere((message) => message.id == messageId);

    if (messageIndex != -1) {
      // print("Message non lu trouvé $messageId");
      messages[messageIndex] = messages[messageIndex].copyWith(isSeen: true);
      await document
          .update({'messages': messages.toList().map((e) => e.toMap())});
    }
  }

  Future<String> uploadFile(String destpath, Uint8List? uint8list) async {
    final fileRef = storage.ref(destpath);
    if (uint8list != null) {
      UploadTask upload = fileRef.putData(
          uint8list,
          SettableMetadata(
              contentType: lookupMimeType("", headerBytes: uint8list)));
      await upload.asStream().last;
      print("fin upload");
      return await fileRef.getDownloadURL();
    }
    return Future.value("");
  }
}

final conversationsRepositoryProvider =
    Provider<ConversationsRepository>((ref) {
  final AuthRepository auth = ref.watch(authRepositoryProvider);
  return ConversationsRepository(
      auth: auth,
      firestore: FirebaseFirestore.instance,
      storage: FirebaseStorage.instance);
});

final conversationWithMembersStreamProvider =
    StreamProvider<List<ConversationWithMembers>>((
  ref,
) {
  final ConversationsRepository repository =
      ref.watch(conversationsRepositoryProvider);
  return repository.getUserConversationsInformationsInRealtime();
});

// C'est celui ci qui foncitonne même sans autoDispose car l'id est passée en para
final conversationWithMembersStreamProvider2 =
    StreamProvider.family<List<ConversationWithMembers>, AppUser?>((ref, user) {
  final ConversationsRepository repository =
      ref.watch(conversationsRepositoryProvider);
  return repository.getUserConversationsInformationsInRealtime2(user);
});
