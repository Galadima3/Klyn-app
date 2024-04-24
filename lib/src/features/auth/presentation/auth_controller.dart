import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:klyn/src/features/auth/data/auth_repository.dart';


enum AuthState { initial, loading, authenticated, unauthenticated }

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(AuthState.initial) {
    // Listen for authentication state changes and update state accordingly
    _authRepository.authStateChange.listen((user) {
      state = user != null ? AuthState.authenticated : AuthState.unauthenticated;
    });
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      state = AuthState.loading;
      await _authRepository.signInWithEmailAndPassword(email, password);
      state = AuthState.authenticated;
    } catch (e) {
      // Handle error
      state = AuthState.unauthenticated;
      rethrow;
    }
  }

  // Sign up with email and password
  Future<void> signUp(String email, String password) async {
    try {
      state = AuthState.loading;
      await _authRepository.signUp(email, password);
      state = AuthState.authenticated;
    } catch (e) {
      // Handle error
      state = AuthState.unauthenticated;
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      state = AuthState.loading;
      await _authRepository.signOut();
      state = AuthState.unauthenticated;
    } catch (e) {
      // Handle error
      state = AuthState.unauthenticated;
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      state = AuthState.loading;
      await _authRepository.resetPassword(email: email);
      state = AuthState.initial;
    } catch (e) {
      // Handle error
      state = AuthState.unauthenticated;
      rethrow;
    }
  }
}

final authControllerProvider = StateNotifierProvider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository);
});
