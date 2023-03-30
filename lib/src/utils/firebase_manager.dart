import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/configs/firebase_options.dart';

class FirebaseManager {
  static Future<void> initialize() async {
    debugPrint("Début initialisation de Firebase");
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint("Fin init firebase");
    } catch (e) {
      debugPrint('Error during Firebase initialization: $e');
    }
  }
}
