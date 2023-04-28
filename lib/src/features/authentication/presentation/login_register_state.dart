// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginRegisterState {
  final AsyncValue value;
  LoginRegisterState({this.value = const AsyncValue.data(null)});

  LoginRegisterState copyWith({
    AsyncValue? value,
  }) {
    return LoginRegisterState(
      value: value ?? this.value,
    );
  }

  @override
  String toString() => 'LoginRegisterState(value: $value)';

  @override
  bool operator ==(covariant LoginRegisterState other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
