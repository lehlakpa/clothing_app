import 'package:clothing_app/bloc/auth_bloc.dart';
import 'package:clothing_app/bloc/auth_event.dart';
import 'package:clothing_app/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothing_app/constants/constants_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // --------------------------------
  // LOGIN
  // --------------------------------
  void login() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Enter username and password',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: ConstantsColors.navyDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
      LoginRequested(username: username, password: password),
    );
  }

  // --------------------------------
  // INPUT FIELD
  // --------------------------------
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: ConstantsColors.fieldBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: ConstantsColors.fieldBorder, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        textInputAction: obscureText
            ? TextInputAction.done
            : TextInputAction.next,
        onSubmitted: obscureText ? (_) => login() : null,
        style: const TextStyle(
          fontSize: 14,
          color: ConstantsColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: ConstantsColors.navyDark, size: 21),
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: ConstantsColors.navyDark,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 17),
        ),
      ),
    );
  }

  // --------------------------------
  // LOGIN BUTTON
  // --------------------------------
  Widget _buildLoginButton(AuthState state) {
    final isLoading = state is AuthLoading;

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading ? null : login,
        style: ElevatedButton.styleFrom(
          backgroundColor: ConstantsColors.navyDark,
          disabledBackgroundColor: ConstantsColors.navyDark.withOpacity(0.65),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
      ),
    );
  }

  // --------------------------------
  // ERROR
  // --------------------------------
  Widget _buildError(AuthState state) {
    if (state is! AuthError) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ConstantsColors.red.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ConstantsColors.red.withOpacity(0.15)),
      ),
      child: Text(
        state.message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: ConstantsColors.red, fontSize: 13),
      ),
    );
  }

  // --------------------------------
  // BUILD
  // --------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --------------------------------
          // SIDE CIRCLES
          // --------------------------------
          // _buildTopCircle(),
          // _buildBottomCircle(),

          // --------------------------------
          // CONTENT
          // --------------------------------
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 35,
                ),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        // Space for top circle
                        const SizedBox(height: 75),
                        Text("username:emilys /pass- emilyspass"),
                        // --------------------------------
                        // TITLE
                        // --------------------------------
                        // const Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         'Welcome Back',
                        //         style: TextStyle(
                        //           fontSize: 28,
                        //           fontWeight: FontWeight.w800,
                        //           color: ink,
                        //         ),
                        //       ),
                        //       SizedBox(height: 7),
                        //       Text(
                        //         'Login to continue to your account',
                        //         style: TextStyle(fontSize: 13, color: muted),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(height: 32),

                        // --------------------------------
                        // LOGIN CARD
                        // --------------------------------
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: ConstantsColors.fieldBorder,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                  color: ConstantsColors.textPrimary,
                                ),
                              ),

                              const SizedBox(height: 25),

                              // USERNAME
                              _buildInputField(
                                controller: usernameController,
                                hintText: 'Username',
                                icon: Icons.person_outline_rounded,
                              ),

                              const SizedBox(height: 16),

                              // PASSWORD
                              _buildInputField(
                                controller: passwordController,
                                hintText: 'Password',
                                icon: Icons.lock_outline_rounded,
                                obscureText: obscurePassword,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20,
                                    color: ConstantsColors.navyDark,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // FORGOT PASSWORD
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: ConstantsColors.navyDark,
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // BLUE BUTTON
                              _buildLoginButton(state),

                              // ERROR
                              _buildError(state),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // --------------------------------
                        // SIGN UP
                        // --------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 13,
                                color: ConstantsColors.navyDark,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to RegisterScreen
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: ConstantsColors.navyDark,
                                padding: const EdgeInsets.only(left: 6),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Space for bottom circle
                        const SizedBox(height: 80),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
