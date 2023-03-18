import 'dart:ffi';

import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/constants/test_messages.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/tchat/domain/message.dart';

abstract class MessageRepository {
  // Stream<List<Message>> messages(); //Le générer comme j'avais fait
  Future<void> sendMessage(Message message); //Ajoute un message au stream
  Future<List<Message>> getMessages(); //Récupère les messages
  void dispose();
}

class FakeMessageRepository extends MessageRepository {
  // @override
  // Stream<List<Message>> messages() => Stream.value(kTestMessage); //Le générer comme j'avais fait

  @override
  Future<void> sendMessage(Message message) {
    return Future.value(null);
  } //Ajoute un message au stream

  @override
  Future<List<Message>> getMessages() {
    return Future.value(kTestMessage);
  }

  @override
  void dispose() => Void;
}

//TODO: Implémenter ça :
// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   const isFake = String.fromEnvironment('useFakeRepos') == 'true';
//   final auth = isFake ? FakeAuthRepository() : FirebaseAuthRepository();
//   ref.onDispose(() {
//     auth.dispose();
//   });
//   return auth;
// });

// //Pourquoi utilise autoDispose puisque l'état du stream est amener à changer.
// //En faite un stream ça envoie des données
// final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
//   final authRepository = ref.watch(authRepositoryProvider);
//   return authRepository.authStateChanges();
// });
