// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

//User properties (Firebase)
//https://firebase.google.com/docs/reference/js/v8/firebase.User

class AppUser {
  User? fbUser;
  String? username;
  String? profilePic;
  bool? isOnline;
  List<String>? groupId;
  AppUser({
    this.fbUser,
    this.username,
    this.profilePic,
    this.isOnline,
    this.groupId,
  });
  

  AppUser copyWith({
    User? fbUser,
    String? username,
    String? profilePic,
    bool? isOnline,
    List<String>? groupId,
  }) {
    return AppUser(
      fbUser: fbUser ?? this.fbUser,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      isOnline: isOnline ?? this.isOnline,
      groupId: groupId ?? this.groupId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'groupId': groupId,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      fbUser: map['fbUser'] != null ? map['fbUser'] as User : null,
      username: map['username'] != null ? map['username'] as String : null,
      profilePic: map['profilePic'] != null ? map['profilePic'] as String : null,
      isOnline: map['isOnline'] != null ? map['isOnline'] as bool : null,
      // groupId: map['groupId'] != null ? List<String>.from((map['groupId'] as List<String>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) => AppUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppUser(fbUser: $fbUser, username: $username, profilePic: $profilePic, isOnline: $isOnline, groupId: $groupId)';
  }

  @override
  bool operator ==(covariant AppUser other) {
    if (identical(this, other)) return true;
  
    return 
      other.fbUser == fbUser &&
      other.username == username &&
      other.profilePic == profilePic &&
      other.isOnline == isOnline &&
      listEquals(other.groupId, groupId);
  }

  @override
  int get hashCode {
    return fbUser.hashCode ^
      username.hashCode ^
      profilePic.hashCode ^
      isOnline.hashCode ^
      groupId.hashCode;
  }
}
