import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:klyn/src/features/auth/presentation/auth_controller.dart';
import 'package:klyn/src/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:klyn/src/routing/route_paths.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  final confirmPasswordFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  bool isPasswordVisible = true;
  bool isPasswordVisible1 = true;

  Future<void> signUpMethod(
      String email, String password, WidgetRef ref) async {
    final auth = ref.read(authControllerProvider.notifier);
    auth.signUp(email, password);
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
                'Create your account',
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
              height: height * 0.025,
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
            SizedBox(
              height: height * 0.025,
            ),

            //confirm password
            Form(
              key: confirmPasswordFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: isPasswordVisible1,
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) => value! == passwordController.text
                      ? null
                      : "Passwords don't match",
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.password),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible1 = !isPasswordVisible1;
                          });
                        },
                        icon: Icon(isPasswordVisible1
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.025,
            ),

            //button
            Consumer(
              builder: (context, ref, child) {
                final authController =
                            ref.watch(authControllerProvider.notifier);
                return GestureDetector(
                  onTap: () {
                    if (emailFormKey.currentState!.validate() &&
                        passwordFormKey.currentState!.validate() &&
                        confirmPasswordFormKey.currentState!.validate()) {
                      try {
                        signUpMethod(
                          emailController.text,
                          passwordController.text,
                          ref,
                        );
                        context.pushNamed(RoutePaths.homeScreenRoute);
                      } catch (e) {
                        
                        context.showSnackbar('Error: $e');
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
                      child: authController.state == AuthState.loading 
                          ? Transform.scale(
                              scale: 0.65,
                              child: const CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.white,
                              ),
                            )
                          : Text(
                              'Sign up',
                              style: GoogleFonts.urbanist(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),

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
                    'Already have an account? ',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pushNamed(RoutePaths.signinScreenRoute),
                    child: Text(
                      'Sign In ',
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

extension CustomError on BuildContext {
  void showSnackbar(String message) => ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(content: Text(message)),
      );
}
