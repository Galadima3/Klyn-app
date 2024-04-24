import 'package:go_router/go_router.dart';
import 'package:klyn/main.dart';
import 'package:klyn/src/features/auth/presentation/auth_checker.dart';
import 'package:klyn/src/features/auth/presentation/screens/landing_screen.dart';
import 'package:klyn/src/features/auth/presentation/screens/register_screen.dart';
import 'package:klyn/src/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:klyn/src/routing/route_paths.dart';

GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: RoutePaths.authCheckerRoute,
      builder: (context, state) => const AuthChecker(),
    ),
    GoRoute(
      path: '/${RoutePaths.landingScreenRoute}',
      name: RoutePaths.landingScreenRoute,
      builder: (context, state) => const LandingScreen(),
      routes: [
        GoRoute(
            path: RoutePaths.registerSreenRoute,
            name: RoutePaths.registerSreenRoute,
            builder: (context, state) => const RegisterScreen()),
        GoRoute(
            path: RoutePaths.signinScreenRoute,
            name: RoutePaths.signinScreenRoute,
            builder: (context, state) => const SignInScreen()),
      ],
    ),
    GoRoute(
      path: '/${RoutePaths.homeScreenRoute}',
      name: RoutePaths.homeScreenRoute,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
