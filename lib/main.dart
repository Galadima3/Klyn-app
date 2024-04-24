import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:klyn/firebase_options.dart';
import 'package:klyn/src/features/auth/data/auth_repository.dart';
import 'package:klyn/src/features/auth/presentation/auth_controller.dart';
import 'package:klyn/src/features/auth/presentation/screens/register_screen.dart';
import 'package:klyn/src/routing/app_router.dart';
import 'package:klyn/src/routing/route_paths.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(user?.displayName ?? "Xxxx"),
          actions: [
            IconButton(
                onPressed: () async {
                  try {
                    await ref.read(authControllerProvider.notifier).signOut();
                    context.pushReplacementNamed(RoutePaths.signinScreenRoute);
                  } catch (e) {
                    context.showSnackbar("Error: $e");
                  }
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Center(
          child: Consumer(
            builder: (context, ref, _) {
              final userDetails = ref.watch(userDetailsProvider);
              if (userDetails.value != null) {
                final email = userDetails.value!.email;
                return Text('Welcome, $email');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ));
  }
}
