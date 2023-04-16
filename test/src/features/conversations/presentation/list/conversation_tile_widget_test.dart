import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/constants/keys.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversation.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/conversationWithMembers.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/list/conversation_tile_widget.dart';

final firestoreInstance = FakeFirebaseFirestore();

final cyril = AppUser(
    //Utilisateur qui sera connecté
    uid: "cyril",
    email: "cyrima@gmail.com",
    username: "Cyril (Moi)",
    profilePic:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-UC25k-l4r8cypZt1JGaoojfI9njAVYnxdyUsKU6T8g&s",
    isOnline: false,
    groupId: []);

final jackMa = AppUser(
    uid: "jackma",
    email: "jackma@gmail.com",
    username: "Jack Ma",
    profilePic:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-UC25k-l4r8cypZt1JGaoojfI9njAVYnxdyUsKU6T8g&s",
    isOnline: false,
    groupId: []);

final john = AppUser(
    uid: "john",
    email: "john@gmail.com",
    username: "john",
    profilePic: "",
    isOnline: false,
    groupId: ["s"]);

List<AppUser> fakeUsers = [cyril, john, jackMa];

void createFakesUsers(List<AppUser> fakeUsers) async {
  for (var user in fakeUsers) {
    await firestoreInstance
        .collection('users')
        .doc(user.uid)
        .set(user.toMap()); // * add en db
    MockFirebaseAuth(
        mockUser: MockUser(
      // * Créer l'user auth
      isAnonymous: false,
      uid: user.uid,
      email: user.email,
      displayName: user.username,
    ));
  }
}

void main() async {
  setUpAll(() async {
    HttpOverrides.global = null;
  });

  group('conversation_tile_widget', () {
    setUp(() async {
      createFakesUsers(fakeUsers);
      final auth = MockFirebaseAuth(
          signedIn: true,
          mockUser: MockUser(
            // * Créer l'user auth
            isAnonymous: false,
            uid: fakeUsers[0].uid,
            email: fakeUsers[0].email,
            displayName: fakeUsers[0].username,
          ));

      // final currentUser = auth.currentUser;

      //Pas besoin des lignes si dessous, elles seront pour tester le controller.
      final authRepositoryProvider = Provider<AuthRepository>((ref) {
        return AuthRepository(auth: auth, firestore: firestoreInstance);
      });
      final myProvider = ProviderContainer().read(authRepositoryProvider);
      final user = await myProvider.retrieveUserFromUid("szadzd");
    });

    testWidgets("2 members, no previous message", (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: ConversationTile(
              actualUserUid: fakeUsers[0].uid,
              conversation: ConversationWithMembers(
                  Conversation(
                      id: "01",
                      members: [cyril.uid, jackMa.uid],
                      ownerId: cyril.uid,
                      lastMessageTimeSent: DateTime.now()),
                  [cyril, jackMa])),
        ),
      )));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(ListTile));

      final title = find.text(jackMa.username);
      final subtitle = find.text("Faites le premier pas ;)");
      final profilPic = find.byKey(keyConversationPictureOfUser);

      expect(title, findsOneWidget);
      expect(subtitle, findsOneWidget);
      expect(profilPic, findsOneWidget);
    });

    testWidgets("2 members, no profil pic", (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: ConversationTile(
              actualUserUid: fakeUsers[0].uid,
              conversation: ConversationWithMembers(
                  Conversation(
                      id: "01",
                      members: [cyril.uid, john.uid],
                      ownerId: cyril.uid,
                      lastMessageTimeSent: DateTime.now()),
                  [cyril, john])),
        ),
      )));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(ListTile));

      final title = find.text(john.username);
      final subtitle = find.text("Faites le premier pas ;)");
      final convPic = find.byKey(keyConversationPictureDefault);

      expect(title, findsOneWidget);
      expect(subtitle, findsOneWidget);
      expect(convPic, findsOneWidget);
    });

    testWidgets("3 members (group), + last message + date", (tester) async {
      const lastMessage = "Coucou les gas !";
      final lastSender = john;

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: ConversationTile(
              actualUserUid: fakeUsers[0].uid,
              conversation: ConversationWithMembers(
                  Conversation(
                      id: "01",
                      members: [cyril.uid, john.uid, jackMa.uid],
                      ownerId: cyril.uid,
                      lastMessage: lastMessage,
                      lastMessageSender: lastSender.username,
                      lastMessageTimeSent: DateTime.now()),
                  [cyril, jackMa, john])),
        ),
      )));
      await tester.pumpAndSettle();

      final title = find.text('Conversation de groupe');
      final subtitle = find.text("${lastSender.username}: $lastMessage");
      final convPic = find.byKey(keyConversationPictureGroupConversation);

      expect(title, findsOneWidget);
      expect(subtitle, findsOneWidget);
      expect(convPic, findsOneWidget);
    });
  });
}

/*
Si je test un widget, ai-je besoin de peupler une fausse base de donnée ?
(+ de créer un faux provider qui utilise la fausse base de donnée).
Rép: pas besoin car comme je test des widgets, je ne peux pas utiliser de controller.
Ce dernier se trouve dans la view. Je dois tester mon widget seulement avec les
paramètres que je lui passe.

Si je test mon controller, la j'aurai besoin d'un fake provider qui utilise de 
fausses instances de auth et de firestore.

*/
