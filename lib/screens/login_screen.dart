import 'package:clothing_app/bloc/auth_bloc.dart';
import 'package:clothing_app/bloc/auth_event.dart';
import 'package:clothing_app/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  // --------------------------------
  // COLORS
  // --------------------------------
  static const Color blue = Color(0xFF11164F);
  static const Color blueDark = Color(0xFF11164F);
  static const Color ink = Color(0xFF1B1B1F);
  static const Color muted = Color(0xFF11164F);
  static const Color fieldBg = Color(0xFFF5F5F7);
  static const Color border = Color(0xFFE4E4E8);

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
          backgroundColor: blue,
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
        color: fieldBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: border, width: 1),
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
          color: ink,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: blue, size: 21),
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14, color: muted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 17),
        ),
      ),
    );
  }

  // --------------------------------
  // TOP RIGHT CIRCLE
  // --------------------------------
  Widget _buildTopCircle() {
    return Positioned(
      top: -125,
      right: -125,
      child: Container(
        width: 270,

        height: 270,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 171, 171, 184),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Stack(
          children: [
            // WHITE OVERLAPPING CIRCLE
            Positioned(
              left: 25,
              bottom: 28,
              child: Container(
                width: 165,
                height: 165,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 47, 6, 233),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------
  // BOTTOM LEFT CIRCLE
  // --------------------------------
  Widget _buildBottomCircle() {
    return Positioned(
      bottom: -135,
      left: -135,
      child: Container(
        width: 290,
        height: 290,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 171, 171, 184),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Stack(
          children: [
            // WHITE OVERLAPPING CIRCLE
            Positioned(
              right: 28,
              top: 28,
              child: Container(
                width: 175,
                height: 175,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 47, 6, 233),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
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
          backgroundColor: blue,
          disabledBackgroundColor: blue.withOpacity(0.65),
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
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_rounded, size: 20),
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
        color: Colors.red.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.15)),
      ),
      child: Text(
        state.message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.red, fontSize: 13),
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
          _buildTopCircle(),
          _buildBottomCircle(),

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

                        // --------------------------------
                        // TITLE
                        // --------------------------------
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: ink,
                                ),
                              ),
                              SizedBox(height: 7),
                              Text(
                                'Login to continue to your account',
                                style: TextStyle(fontSize: 13, color: muted),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // --------------------------------
                        // LOGIN CARD
                        // --------------------------------
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: border, width: 1),
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
                                  color: ink,
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
                                    color: muted,
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
                                    foregroundColor: blue,
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
                              style: TextStyle(fontSize: 13, color: muted),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to RegisterScreen
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: blue,
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
