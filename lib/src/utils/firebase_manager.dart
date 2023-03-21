import 'package:firebase_core/firebase_core.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/configs/firebase_options.dart';

class FirebaseManager {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      print('Error during Firebase initialization: $e');
    }
  }
}
