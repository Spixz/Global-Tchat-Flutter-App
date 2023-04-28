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

class FirebaseStorageRepository {
  final FirebaseStorage storage;

  FirebaseStorageRepository(
      {required this.storage});

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

final firebaseStorageRepositoryProvider =
    Provider<FirebaseStorageRepository>((ref) {
  return FirebaseStorageRepository(
      storage: FirebaseStorage.instance);
});