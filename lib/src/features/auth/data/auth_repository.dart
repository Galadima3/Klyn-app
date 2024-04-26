import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get userDetails => _auth.currentUser;
  Stream<User?> get authStateChange => _auth.idTokenChanges();

  Future<User?> signInWithEmailAndPassword(
  String email, String password) async {
  try {
    final result = await _auth.signInWithEmailAndPassword(
      email: email, password: password);
    log('Sign in successful');
    return result.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      throw AuthException('The email address is not registered. Please sign up.');
    } else {
      final errorMessage = _getErrorMessage(e);
      log(errorMessage);
      throw AuthException(errorMessage);
    }
  }
}


  Future<User?> signUp(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      log(result.user.toString());
      log('Sign up successful');
      _firestore
          .collection('users')
          .doc(result.user!.uid)
          .set({'uid': result.user!.uid, 'email': result.user!.email}).then(
              (value) => log("Record added"));
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
  return AuthRepository();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChange;
});

final userDataProvider = Provider.autoDispose<User?>((ref) {
  return ref.watch(authRepositoryProvider).userDetails;
});

final userDetailsProvider = FutureProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).userDetails;
});
