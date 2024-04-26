import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:klyn/src/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:klyn/src/features/chat/presentation/home_screen.dart';

// class AuthChecker extends ConsumerWidget {
//   const AuthChecker({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authStateProvider);
//     return authState.maybeWhen(
//       data: (user) =>
//           user != null ? const LandingScreen() : const SignInScreen(),
//       orElse: () => Scaffold(
//         appBar: AppBar(),
//         body: const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }
// }

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
