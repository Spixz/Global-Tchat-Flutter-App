// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Simple class representing the user UID and email.
class AppUserOld {
  final String uid;
  final String email;
  AppUserOld({
    required this.uid,
    required this.email,
  });

  AppUserOld copyWith({
    String? uid,
    String? email,
  }) {
    return AppUserOld(
      uid: uid ?? this.uid,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
    };
  }

  factory AppUserOld.fromMap(Map<String, dynamic> map) {
    return AppUserOld(
      uid: map['uid'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUserOld.fromJson(String source) =>
      AppUserOld.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AppUser(uid: $uid, email: $email)';

  @override
  bool operator ==(covariant AppUserOld other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.email == email;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;
}
