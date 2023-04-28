// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';


class AccountState {
  final AsyncValue value;
  final AppUser? user;
  AccountState({
    required this.value,
    this.user,
  });

  AccountState copyWith({
    AsyncValue? value,
    AppUser? user,
  }) {
    return AccountState(
      value: value ?? this.value,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
      'user': user?.toMap(),
    };
  }

  factory AccountState.fromMap(Map<String, dynamic> map) {
    return AccountState(
      value: map['value'],
      user: map['user'] != null
          ? AppUser.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountState.fromJson(String source) =>
      AccountState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AccountState(value: $value, user: $user)';

  @override
  bool operator ==(covariant AccountState other) {
    if (identical(this, other)) return true;

    return other.value == value && other.user == user;
  }

  @override
  int get hashCode => value.hashCode ^ user.hashCode;
}
