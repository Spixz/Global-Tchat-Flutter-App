import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple class representing the user UID and email.
class AppUser {
  const AppUser({
    required this.uid,
    this.email,
  });
  final String uid;
  final String? email;
}

final userProvider = StateProvider<AppUser>((ref) {
  return const AppUser(uid: "Andrea");
});
