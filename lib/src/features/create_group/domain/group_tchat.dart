// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class GroupTchat {
  final String id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String ownerId;
  final List<String> members;
  final List<String>? admins;
  final List<String>? banned;
  GroupTchat({
    required this.id,
    this.name,
    this.description,
    this.imageUrl,
    required this.ownerId,
    required this.members,
    this.admins,
    this.banned,
  });

  GroupTchat copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? ownerId,
    List<String>? members,
    List<String>? admins,
    List<String>? banned,
  }) {
    return GroupTchat(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerId: ownerId ?? this.ownerId,
      members: members ?? this.members,
      admins: admins ?? this.admins,
      banned: banned ?? this.banned,
    );
  }

  Map<String, dynamic> toMap({bool withId = true}) {
    return <String, dynamic>{
      ...withId ? {'id': id} : {},
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'members': members,
      'admins': admins,
      'banned': banned,
    };
  }

  factory GroupTchat.fromMap(Map<String, dynamic> map) {
    return GroupTchat(
      id: map['id'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      ownerId: map['ownerId'] as String,
      members: List<String>.from((map['members'] as List<String>)),
      admins: map['admins'] != null
          ? List<String>.from((map['admins'] as List<String>))
          : null,
      banned: map['banned'] != null
          ? List<String>.from((map['banned'] as List<String>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupTchat.fromJson(String source) =>
      GroupTchat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GroupTchat(id: $id, name: $name, description: $description, imageUrl: $imageUrl, ownerId: $ownerId, members: $members, admins: $admins, banned: $banned)';
  }

  @override
  bool operator ==(covariant GroupTchat other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.ownerId == ownerId &&
        listEquals(other.members, members) &&
        listEquals(other.admins, admins) &&
        listEquals(other.banned, banned);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        ownerId.hashCode ^
        members.hashCode ^
        admins.hashCode ^
        banned.hashCode;
  }
}
