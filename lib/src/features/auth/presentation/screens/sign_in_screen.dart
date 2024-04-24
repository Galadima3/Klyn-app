import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:klyn/src/features/auth/presentation/auth_controller.dart';
import 'package:klyn/src/features/auth/presentation/screens/register_screen.dart';
import 'package:klyn/src/routing/route_paths.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();

  bool isPasswordVisible = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signInMethod(
      String email, String password, WidgetRef ref) async {
    FocusManager.instance.primaryFocus?.unfocus();

    ref
        .read(authControllerProvider.notifier)
        .signInWithEmailAndPassword(email, password);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    //print(height);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //text
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'Login to your Account',
                style: GoogleFonts.urbanist(
                  fontSize: 39,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            SizedBox(
              height: height * 0.045,
            ),

            //email
            Form(
              key: emailFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: emailController,
                  validator: (value) => EmailValidator.validate(value!)
                      ? null
                      : "Please enter a valid email",
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.035,
            ),
            //password
            Form(
              key: passwordFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: isPasswordVisible,
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) => value!.length > 6
                      ? null
                      : "Password should be more than 6 characters",
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.password),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: Icon(isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            //checkbox
            InkWell(
              // onTap: () => Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) {
              //     return const ResetPasswordScreen();
              //   },
              // )),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: GoogleFonts.urbanist(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.025,
            ),

            //button
            Consumer(builder: (context, ref, child) {
              final isLoading = ref.watch(authControllerProvider.notifier);
              return InkWell(
                onTap: () {
                  if (emailFormKey.currentState!.validate() &&
                      passwordFormKey.currentState!.validate()) {
                    try {
                      signInMethod(
                          emailController.text, passwordController.text, ref);
                      context.pushReplacementNamed(RoutePaths.homeScreenRoute);
                    } catch (e) {
                      context.showSnackbar("Error: $e");
                    }
                  }
                },
                child: Container(
                  width: 328,
                  height: 53,
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
                  child: Center(
                    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                    child: isLoading.state == AuthState.loading
                        ? Transform.scale(
                            scale: 0.65,
                            child: const CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.white,
                            ),
                          )
                        : Text(
                            'Sign In',
                            style: GoogleFonts.urbanist(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              );
            }),

            const SizedBox(
              height: 15,
            ),
            //text
            Padding(
              padding: const EdgeInsets.only(right: 13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: GoogleFonts.urbanist(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                   onTap: () => context.pushNamed(RoutePaths.registerSreenRoute),
                    child: Text(
                      'Sign up',
                      style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
