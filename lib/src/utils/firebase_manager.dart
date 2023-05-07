import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/configs/firebase_options.dart';

// final STATE = dotenv.env['STATE'];

class FirebaseManager {
  static Future<void> initialize() async {
    debugPrint("Début initialisation de Firebase");
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
        const host = kIsWeb ? "localhost" : "192.168.1.42"; //"10.0.2.2";
        // await FirebaseAuth.instance.useAuthEmulator(host, 9099);
        // FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
        // await FirebaseStorage.instance.useStorageEmulator(host, 9199);
      debugPrint("Fin init firebase");
    } catch (e) {
      debugPrint('Error during Firebase initialization: $e');
    }
  }
}
