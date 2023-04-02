// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

//User properties (Firebase)
//https://firebase.google.com/docs/reference/js/v8/firebase.User

class AppUser {
  final String uid;
  final String email;
  final String username;
  final String profilePic;
  final bool isOnline;
  final List<String> groupId;
  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    required this.profilePic,
    required this.isOnline,
    required this.groupId,
  });

  AppUser copyWith({
    String? uid,
    String? email,
    String? username,
    String? profilePic,
    bool? isOnline,
    List<String>? groupId,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      isOnline: isOnline ?? this.isOnline,
      groupId: groupId ?? this.groupId,
    );
  }

//sinon il va me stocker l'uid en DB
  Map<String, dynamic> toMap({bool withUid = true}) {
    return <String, dynamic>{
      ...withUid ? {'uid': uid} : {},
      'email': email,
      'username': username,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'groupId': groupId,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      profilePic: map['profilePic'] as String,
      isOnline: map['isOnline'] as bool,
      groupId: List<String>.from((map['groupId'] as List<String>)),
    );
  }

//Si une clé n'est pas présente dans la map, on utilise la valeur existante.
  copyWithFromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map.containsKey('uid') ? map['uid'] as String : uid,
      email: map.containsKey('email') ? map['email'] as String : email,
      username:
          map.containsKey('username') ? map['username'] as String : username,
      profilePic: map.containsKey('profilePic')
          ? map['profilePic'] as String
          : profilePic,
      isOnline:
          map.containsKey('isOnline') ? map['isOnline'] as bool : isOnline,
      groupId: map.containsKey('groupId')
          ? List<String>.from((map['groupId'] as List<String>))
          : groupId,
    );
  }

  String toJson() => json.encode(toMap());

  static List<String> properties = [
    "uid",
    "email",
    "username",
    "profilePic",
    "isOnline",
    "groupId",
  ];

  // factory AppUser.fromJson(String source) => AppUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, username: $username, profilePic: $profilePic, isOnline: $isOnline, groupId: $groupId)';
  }

  @override
  bool operator ==(covariant AppUser other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.username == username &&
        other.email == email &&
        other.profilePic == profilePic &&
        other.isOnline == isOnline &&
        listEquals(other.groupId, groupId);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        username.hashCode ^
        profilePic.hashCode ^
        isOnline.hashCode ^
        groupId.hashCode;
  }
}
