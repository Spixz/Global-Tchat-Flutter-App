// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountState {
  final AsyncValue value;
  AccountState({this.value = const AsyncValue.data(null)});

  AccountState copyWith({
    AsyncValue? value,
  }) {
    return AccountState(
      value: value ?? this.value,
    );
  }

  @override
  String toString() => 'LoginRegisterState(value: $value)';

  @override
  bool operator ==(covariant AccountState other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
