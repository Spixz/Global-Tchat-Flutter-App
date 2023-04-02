// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/account/domain/app_user.dart';

class CreateGroupState {
  final AsyncValue value;
  final String searchQuery;
  final List<AppUser> allUsersList;
  final List<AppUser> searchResults;
  final List<AppUser> selectedUsers;

  CreateGroupState({
    this.value = const AsyncData(null),
    this.searchQuery = "",
    this.allUsersList = const [],
    this.searchResults = const [],
    this.selectedUsers = const [],
  });

  CreateGroupState copyWith({
    AsyncValue? value,
    String? searchQuery,
    List<AppUser>? allUsersList,
    List<AppUser>? searchResults,
    List<AppUser>? selectedUsers,
  }) {
    return CreateGroupState(
      value: value ?? this.value,
      searchQuery: searchQuery ?? this.searchQuery,
      allUsersList: allUsersList ?? this.allUsersList,
      searchResults: searchResults ?? this.searchResults,
      selectedUsers: selectedUsers ?? this.selectedUsers,
    );
  }

  @override
  String toString() {
    return 'CreateGroupState(value: $value, searchQuery: $searchQuery, allUsersList: $allUsersList, searchResults: $searchResults, selectedUsers: $selectedUsers)';
  }

  @override
  bool operator ==(covariant CreateGroupState other) {
    if (identical(this, other)) return true;
  
    return 
      other.value == value &&
      other.searchQuery == searchQuery &&
      listEquals(other.allUsersList, allUsersList) &&
      listEquals(other.searchResults, searchResults) &&
      listEquals(other.selectedUsers, selectedUsers);
  }

  @override
  int get hashCode {
    return value.hashCode ^
      searchQuery.hashCode ^
      allUsersList.hashCode ^
      searchResults.hashCode ^
      selectedUsers.hashCode;
  }
}