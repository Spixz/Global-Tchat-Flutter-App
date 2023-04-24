import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/enums/message_type.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/data/conversations_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/domain/message.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/conversations/presentation/display/display_conversation_state.dart';

class DisplayConversationController
    extends StateNotifier<DisplayConversationState> {
  final ConversationsRepository conversationsRepository;
  final AuthRepository authRepository;

  DisplayConversationController(
      {required this.authRepository,
      required this.conversationsRepository,
      required conversationId})
      : super(DisplayConversationState(
            value: const AsyncData(null),
            currentUserUid: authRepository.currentUser!.uid,
            conversationId: conversationId)) {
    listenUserConversationInformationStream();
    listenMessagesFromConversationStream();
  }

//Ecoute le stream des informations des conversations et modifie le state
//quand une information sur la conversation ciblée est modifiée.
  void listenUserConversationInformationStream() {
    conversationsRepository.getUserConversationsInformationsInRealtime().listen(
      (event) {
        try {
          var conv =
              event.firstWhere((element) => element.id == state.conversationId);
          state = state.copyWith(conversationInformations: conv);
          _addUsernamesToMessages();
        } catch (err, st) {
          print("Erreur dans listenUserConversationInformationStream");
          print(st);
          state = state.copyWith(value: AsyncError(err, st));
        }
      },
      onError: (err, st) {
        state = state.copyWith(value: AsyncError(err, st));
        debugPrint(st);
      },
    );
  }

  void listenMessagesFromConversationStream() {
    debugPrint(
        "Dans listenMessagesFromConversationStream ${state.conversationId}");
    conversationsRepository
        .getMessagesFromConversationInRealtime(state.conversationId)
        .listen(
      (messagesInstance) async {
        try {
          debugPrint("Un nouveau message à été émis dans une conv de l'user");
          state = state.copyWith(messagesFromConversation: messagesInstance);
          _addUsernamesToMessages();
        } catch (err, st) {
          state = state.copyWith(value: AsyncError(err, st));
        }
      },
      onError: (err, st) {
        state = state.copyWith(value: AsyncError(err, st));
        print(st);
      },
    );
  }

//message collction est vide, il faut fixer ça.
  Future<void> sendMessage(MessageType type, String content) async {
    final newMsg = Message(
        id: "",
        content: content,
        senderId: state.currentUserUid,
        createdAt: DateTime.now(),
        type: MessageType.text,
        isSeen: false,
        repliedTo: "",
        repliedMessage: "",
        repliedMessageType: type);
    print("Message envoyé");
    print(newMsg);
    await conversationsRepository.sendMessage(state.conversationId, newMsg);
  }

  void sendFile(String fileDest, Uint8List? uint8list) async {
    state = state.copyWith(value: const AsyncLoading());
    final value = await AsyncValue.guard(() async {
      final link =
          await conversationsRepository.uploadFile(fileDest, uint8list);
      await sendMessage(MessageType.image, link);
    });
    state = state.copyWith(value: value);
  }

//Ajoute le nom des users aux messages grâce à leurs uids.
  void _addUsernamesToMessages() {
    if (state.conversationInformations != null &&
        state.messagesFromConversation != null) {
      List<Message> msg = [];
      for (var message in state.messagesFromConversation!.messages) {
        String senderUser = state.conversationInformations!.membersFilled
            .firstWhere((element) => element.uid == message.senderId)
            .username;

        String repliedToUsername = (message.repliedTo.isNotEmpty)
            ? state.conversationInformations!.membersFilled
                .firstWhere(
                    (element) => element.uid == message.repliedToUsername)
                .username
            : "";
        msg.add(message.copyWith(
            senderUsername: senderUser, repliedToUsername: repliedToUsername));
      }

      state = state.copyWith(
          messagesFromConversation:
              state.messagesFromConversation!.copyWith(messages: msg));
    }
  }
}

final displayConversationControllerProvider = StateNotifierProvider.family<
    DisplayConversationController,
    DisplayConversationState,
    String>((ref, conversationId) {
  final ConversationsRepository conversationsRepo =
      ref.watch(conversationsRepositoryProvider);
  final AuthRepository authRepo = ref.watch(authRepositoryProvider);

  return DisplayConversationController(
      authRepository: authRepo,
      conversationsRepository: conversationsRepo,
      conversationId: conversationId);
});
