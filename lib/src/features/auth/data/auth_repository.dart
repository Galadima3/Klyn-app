import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);

  User? get userDetails => _auth.currentUser;
  Stream<User?> get authStateChange => _auth.idTokenChanges();

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      log('Sign in successful');
      return result.user;
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e);
      log(errorMessage);
      throw AuthException(errorMessage);
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      log('Sign up successful');
      return result.user;
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e);
      log(errorMessage);
      throw AuthException(errorMessage);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'User not found';
      case 'wrong-password':
        return 'Wrong password';
      default:
        return e.message ?? 'An error occurred. Please try again later';
    }
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}

//Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChange;
});

final userDataProvider = Provider<User?>((ref) {
  return ref.watch(authRepositoryProvider).userDetails;
});

final userDetailsProvider = FutureProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).userDetails;
});
