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

class FirestoreRepository {
  final FirebaseFirestore storage;

  FirestoreRepository(
      {required this.storage});

//Si le document n'existe pas, il est créer.
  Future<void> updateDocument(String collectionName, String documentId, Map<String, dynamic> data) async {
    final collection = storage.collection(collectionName);
    try {
      await collection.doc(documentId).update(data);
      debugPrint("Document $documentId mis à jour dans $collectionName");
    } catch (err) {
      debugPrint("Le doc $documentId corespondant n'existant pas, il a été créer.");
      await collection.doc(documentId).set(data);
    }
  }
}

final firestoreRepositoryProvider =
    Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(
      storage: FirebaseFirestore.instance);
});