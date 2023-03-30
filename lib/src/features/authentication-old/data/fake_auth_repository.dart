import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication-old/domain/app_user.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

// abstract class AuthRepository {
//   Stream<AppUser?> authStateChanges();
//   AppUser? get currentUser;
//   Future<void> signInWithEmailAndPassword(String email, String password);
//   Future<void> createUserWithEmailAndPassword(String email, String password);
//   Future<void> signOut();
//   void dispose();
// }

// class FirebaseAuthRepository extends AuthRepository {
//   @override
//   Stream<AppUser?> authStateChanges() {
//     // TODO: implement authStateChanges
//     throw UnimplementedError();
//   }

//   @override
//   Future<dynamic> createUserWithEmailAndPassword(
//       String email, String password) {
//     print("Dans le firebase");
//     return FirebaseAuth.instance
//         .createUserWithEmailAndPassword(email: email, password: password);
//   }

//   @override
//   // TODO: implement currentUser
//   AppUser? get currentUser => throw UnimplementedError();

//   @override
//   Future<void> signInWithEmailAndPassword(String email, String password) {
//     // TODO: implement signInWithEmailAndPassword
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> signOut() {
//     // TODO: implement signOut
//     throw UnimplementedError();
//   }

//   @override
//   void dispose() {}
// }

// class FakeAuthRepository extends AuthRepository {
//   final _authState = InMemoryStore<AppUser?>(null);

//   @override
//   Stream<AppUser?> authStateChanges() => _authState.stream;

//   @override
//   AppUser? get currentUser => _authState.value;

//   @override
//   Future<void> signInWithEmailAndPassword(String email, String password) async {
//     if (currentUser == null) createNewUser(email, password);
//   }

//   @override
//   Future<void> createUserWithEmailAndPassword(
//       String email, String password) async {
//     if (currentUser == null) createNewUser(email, password);
//   }

//   @override
//   Future<void> signOut() async {
//     await Future.delayed(const Duration(seconds: 3));
//     // throw Exception("Une erreur s'est produite, dommage.");
//     _authState.value = null;
//   }

//   //Ne s'appel pas automatiquement
//   @override
//   void dispose() => _authState.close();

//   void createNewUser(String email, String password) {
//     print("Load registering new user: $email");
//     _authState.value = AppUser(
//       uid: const Uuid().v1(),
//       email: email,
//     );
//   }
// }

// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   const isFake = String.fromEnvironment('useFakeRepos') == 'true';
//   final auth = isFake ? FakeAuthRepository() : FakeAuthRepository();
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
