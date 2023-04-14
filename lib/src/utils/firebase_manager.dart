import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/configs/firebase_options.dart';

final STATE = dotenv.env['STATE'];


class FirebaseManager {
  static Future<void> initialize() async {
    debugPrint("Début initialisation de Firebase");
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (STATE == 'debug') {
        await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
        FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      }
      debugPrint("Fin init firebase");
    } catch (e) {
      debugPrint('Error during Firebase initialization: $e');
    }
  }
}
