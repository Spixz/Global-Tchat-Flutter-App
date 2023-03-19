import 'dart:async';
import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/constants/test_messages.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/tchat/domain/message.dart';

abstract class MessageRepository {
  // Stream<List<Message>> messages(); //Le générer comme j'avais fait
  Future<void> sendMessage(Message message); //Ajoute un message au stream
  Future<List<Message>> getMessages(); //Récupère les messages
  Stream<List<Message>> getMessagesByStream();
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
    return Future.delayed(const Duration(seconds: 2), () => kTestMessage);
  }

  //* = stream générator
  @override
  Stream<List<Message>> getMessagesByStream() async* {
    final List<String> senders = ["Pierre", "Paul", "Jacques", "Marie", "Jean"];
    var allMessages = List<Message>.from(kTestMessage);
    int k = 0;
    print('started generating values...');
    while (k < 100) {
      var newSmg = Message(
          id: "${k + 1}",
          content: "New msg : $k",
          senderId: senders[k % senders.length],
          createdAt: DateTime.now());
      allMessages.add(newSmg);
      yield allMessages;
      print(allMessages);
      print("nouvel ajout $k");
      k += 1;
      await Future.delayed(const Duration(seconds: 3));
    }
    print('ended generating values...');
  }

  @override
  void dispose() => Void;
}

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  const isFake = String.fromEnvironment('useFakeRepos') == 'true';
  final messageRepository =
      isFake ? FakeMessageRepository() : FakeMessageRepository();
  ref.onDispose(() {
    messageRepository.dispose();
  });
  return messageRepository;
});

//Si pas de auto dispose, le stream continue d'envoyer les données.
// ! Quand on utilise un stream, il faut toujours utilser autoDispose
//KeepAlive peut permettre de garder le stream en vie pendant un certain temps
//après avoir quitté la page (utile pour économiser des calls api).
final messagesStreamProvider = StreamProvider.autoDispose((ref) {
  final messageRepository = ref.watch(messageRepositoryProvider);
  ref.onDispose(() => print('dispose stream'));
  // var link = ref.keepAlive();
  // Timer(const Duration(seconds: 30), () => link.close());
  return messageRepository.getMessagesByStream();
});

// * Si pas de auto dispose, alors la données est mise en cache.
// * La prochaine fois que la furure sera appelé alors la réponse sera instantané.
//Il faut utiliser autoDispose pour que la future soit appelé à chaque fois.
//Pour reset le state lors du prochain rappel
final messagesFutureProvider = FutureProvider((ref) {
  final messageRepository = ref.watch(messageRepositoryProvider);
  return messageRepository.getMessages();
});

// //Pourquoi utilise autoDispose puisque l'état du stream est amener à changer.
// //En faite un stream ça envoie des données
// final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
//   final authRepository = ref.watch(authRepositoryProvider);
//   return authRepository.authStateChanges();
// });
