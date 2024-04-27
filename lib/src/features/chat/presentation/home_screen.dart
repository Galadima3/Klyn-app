// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:klyn/src/features/auth/data/auth_repository.dart';
import 'package:klyn/src/features/auth/presentation/screens/register_screen.dart';
import 'package:klyn/src/features/chat/presentation/user_list.dart';
import 'package:klyn/src/routing/route_paths.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataProvider);
    log(user.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(user?.email ?? "Xxxx"),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  await ref.read(authRepositoryProvider).signOut();
                  context.pushReplacementNamed(RoutePaths.signinScreenRoute);
                } catch (e) {
                  context.showSnackbar("Error: $e");
                }
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const UserList();
          },
        )),
        child: const Icon(Icons.list),
      ),
      body: Center( 
        child: Text('Welcome 👋: ${user?.email ?? ""}'),
        //TODO: Bring Chat List to home Screen
      ),
    );
  }
}
