import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyn/src/features/auth/data/auth_repository.dart';
import 'package:klyn/src/features/auth/presentation/screens/landing_screen.dart';
import 'package:klyn/src/features/auth/presentation/screens/sign_in_screen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.maybeWhen(
      data: (user) =>
          user != null ? const LandingScreen() : const SignInScreen(),
      orElse: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
