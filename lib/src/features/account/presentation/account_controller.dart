import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/data/auth_repository.dart';
import 'package:riverpod_architecture_template_trom_andrea_bizzotto_course/src/features/authentication/presentation/login_register_state.dart';

/*
 ! Le controller:
 - hold business logic
 - manage the widget state
 - interact with repositories in the data layer
*/

class AccountController extends StateNotifier<AccountState> {
  final AuthRepository auth;
  AccountController({required this.auth}) : super(AccountState());

  Future<dynamic> signOut() async {
    state = state.copyWith(value: const AsyncLoading());
    final data = await AsyncValue.guard(() => auth.signOut());
    state = state.copyWith(value: data);
  }
}

final accountControllerProvider =
    StateNotifierProvider<AccountController, AccountState>((ref) {
  final AuthRepository auth = ref.watch(authRepositoryProvider);
  return AccountController(auth: auth);
});
