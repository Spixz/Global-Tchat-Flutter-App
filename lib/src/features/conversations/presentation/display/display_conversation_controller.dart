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
            currentUserUid: "",
            conversationId: conversationId)) {
    listenUserIdentyStream();
    listenUserConversationInformationStream();
    listenMessagesFromConversationStream();
    // conversationsRepository.fuck().listen((event) {
    //   print("du nouveau dans la collecitons message!");
    // });
  }

  void listenUserIdentyStream() {
    authRepository.userStream().listen((event) async {
      if (authRepository.currentUser != null) {
        print(
            "L'user id actuel depuis le display controller est : ${authRepository.currentUser!.uid}");
        state = state.copyWith(currentUserUid: authRepository.currentUser!.uid);
      }
    });
  }

//Ecoute le stream des informations des conversations et modifie le state
//quand une information sur la conversation ciblée est modifiée.
  void listenUserConversationInformationStream() {
    conversationsRepository.getUserConversationsInformationsInRealtime().listen(
      (event) {
        try {
          var conv =
              event.firstWhere((element) => element.id == state.conversationId);
          state = state.copyWith(bindedConversation: conv);
          print(state.bindedConversation);
        } catch (err, st) {
          state = state.copyWith(value: AsyncError(err, st));
        }
      },
      onError: (err, st) {
        state = state.copyWith(value: AsyncError(err, st));
        //TODO: handle les erreurs dans la view
      },
    );
  }

  void listenMessagesFromConversationStream() {
    //TODO: En dernier recours, je peux envoyer l'id de la conv au stream du repo.
    conversationsRepository
        .getMessagesFromConversationInRealtime(state.conversationId)
        .listen(
      (messages) async {
        try {
          print("Un nouveau message à été émis dans une conv de l'user");
          // print(messages);
          state = state.copyWith(messagesCollection: messages);
          //n'a pas rebuild le widget ?!
        } catch (err, st) {
          state = state.copyWith(value: AsyncError(err, st));
        }
      },
      onError: (err, st) {
        state = state.copyWith(value: AsyncError(err, st));
        //TODO: handle les erreurs dans la view
      },
    );
  }

//message collction est vide, il faut fixer ça.
  Future<void> sendMessage(String message) async {
    final newMsg = Message(
        id: "",
        content: message,
        senderId: state.currentUserUid,
        createdAt: DateTime.now(),
        type: MessageType.text,
        isSeen: false,
        repliedTo: "",
        repliedMessage: "",
        repliedMessageType: MessageType.text);
    await conversationsRepository.sendMessage(state.conversationId, newMsg);
  }
}

final displayConversationControllerProvider = StateNotifierProvider.family
    .autoDispose<DisplayConversationController, DisplayConversationState,
        String>((ref, conversationId) {
  final ConversationsRepository conversationsRepo =
      ref.watch(conversationsRepositoryProvider);
  final AuthRepository authRepo = ref.watch(authRepositoryProvider);

  return DisplayConversationController(
      authRepository: authRepo,
      conversationsRepository: conversationsRepo,
      conversationId: conversationId);
});
