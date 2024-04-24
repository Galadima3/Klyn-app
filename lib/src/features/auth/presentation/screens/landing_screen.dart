import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:klyn/src/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:klyn/src/features/auth/presentation/screens/register_screen.dart';
import 'package:klyn/src/routing/route_paths.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Logo
          SvgPicture.asset(
            'asset/images/flutter.svg',
            height: 150,
            width: 250,
          ),
          const SizedBox(
            height: 35,
          ),

          Center(
            child: GestureDetector(
              onTap: () => context.pushNamed(RoutePaths.registerSreenRoute),
              child: Container(
                height: 50,
                width: 285,
                decoration: ShapeDecoration(
                  color: const Color(0xFF1AB65C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26.50),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 5,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Create an account ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          // Center(
          //   child: Container(
          //     height: 50,
          //     width: 285,
          //     decoration: BoxDecoration(
          //         color: Colors.white70,
          //         borderRadius: BorderRadius.circular(12)),
          //     child: const Center(
          //       child: Text('Log in to an existing account '),
          //     ),
          //   ),
          // ),
          GestureDetector(
            onTap: () => context.pushNamed(RoutePaths.signinScreenRoute),
            child: Container(
                width: 285,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[300],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      offset: const Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4.0, -4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    )
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade200,
                      Colors.grey.shade300,
                      Colors.grey.shade400,
                      Colors.grey.shade500,
                    ],
                    stops: const [0.1, 0.3, 0.8, 1],
                  ),
                ),
                child:
                    const Center(child: Text('Log in to an existing account'))),
          )
        ],
      ),
    );
  }
}
