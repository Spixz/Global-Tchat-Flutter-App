import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/tchat/domain/message.dart';

final kTestMessage = [
  Message(
      id: '1',
      content: 'Salut je suis le premier message',
      senderId: 'Andrea',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5))),
  Message(
      id: '2',
      content: 'Salut Andrea !',
      senderId: 'Jack',
      createdAt: DateTime.now().subtract(const Duration(minutes: 4))),
  Message(
      id: '3',
      content: 'Ca va Jack ?',
      senderId: 'Andrea',
      createdAt: DateTime.now().subtract(const Duration(minutes: 3))),
  Message(
      id: '4',
      content:
          "Ouais parfaitement, j'écris un long texte pour voir si le texte va sortir de la taille qui a été délimité par notre dév",
      senderId: 'Jack',
      createdAt: DateTime.now().subtract(const Duration(minutes: 2))),
  Message(
      id: '5',
      content: 'Coucou les gens',
      senderId: 'Paul',
      createdAt: DateTime.now().subtract(const Duration(minutes: 1))),
  Message(
      id: '6',
      content:
          "bonjour tout le monde, je suis partrick et je suis nouveau sur cette application. Elle à l'air pas mal.",
      senderId: 'Patrick',
      createdAt: DateTime.now().subtract(const Duration(minutes: 0))),
  Message(
      id: '7',
      content: 'Ca va Jack ?',
      senderId: 'Andrea',
      createdAt: DateTime.now().subtract(const Duration(minutes: 3))),
  Message(
      id: '8',
      content: "Ouais parfaitement, merci de demander :)",
      senderId: 'Jack',
      createdAt: DateTime.now().subtract(const Duration(minutes: 2))),
  Message(
      id: '9',
      content: 'Coucou les gens',
      senderId: 'Paul',
      createdAt: DateTime.now().subtract(const Duration(minutes: 1))),
  Message(
      id: '10',
      content:
          "bonjour tout le monde, je suis partrick et je suis nouveau sur cette application. Elle à l'air pas mal.",
      senderId: 'Patrick',
      createdAt: DateTime.now().subtract(const Duration(minutes: 0))),
];
