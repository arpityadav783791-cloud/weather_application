import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_application/main.dart';
import 'package:weather_application/core/app_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;
  bool rememberMe = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override 
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode
        ? const Color(0xFF06172D)
        : const Color(0xFFF7FAFF);

    final cardColor = isDarkMode
        ? const Color(0xFF10243C)
        : Colors.white;

    final primaryTextColor = isDarkMode
        ? Colors.white
        : const Color(0xFF101828);

    final secondaryTextColor = isDarkMode
        ? const Color(0xFF9CAEC4)
        : const Color(0xFF667085);

    final borderColor = isDarkMode
        ? const Color(0xFF29415E)
        : const Color(0xFFD8E1EE);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: borderColor,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () async{
                      final newDarkMode = !isDarkMode;

                      themeNotifier.value = newDarkMode?ThemeMode.dark:ThemeMode.light;
                      await AppStorage.saveTheme(
                        newDarkMode,
                      );
                    },
                    icon: Icon(
                      isDarkMode
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: isDarkMode
                          ? Colors.white
                          : const Color(0xFF246BFD),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF246BFD),
                      Color(0xFF0B4FCB),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF246BFD)
                          .withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 13,
                      right: 12,
                      child: Icon(
                        Icons.wb_sunny_rounded,
                        color: Color(0xFFFFC928),
                        size: 30,
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Icon(
                        Icons.cloud_rounded,
                        color: Colors.white,
                        size: 46,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              Text(
                'Welcome Back!',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Login to continue',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 38),

              Form(
                key: formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: emailController,
                      hintText: 'Email address',
                      icon: Icons.mail_outline_rounded,
                      isDarkMode: isDarkMode,
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textColor: primaryTextColor,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final email = value?.trim() ?? '';

                        if (email.isEmpty) {
                          return 'Please enter your email';
                        }

                        final emailPattern = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        );

                        if (!emailPattern.hasMatch(email)) {
                          return 'Please enter a valid email';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      icon: Icons.lock_outline_rounded,
                      isDarkMode: isDarkMode,
                      cardColor: cardColor,
                      borderColor: borderColor,
                      textColor: primaryTextColor,
                      obscureText: obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _login();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                    
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }

                        return null;
                      },
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
                          color: secondaryTextColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
                     
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: rememberMe,
                            activeColor: const Color(0xFF246BFD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value ?? false;
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        Text(
                          'Remember me',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 14,
                          ),
                        ),

                        const Spacer(),

                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                          ),
                        ),
                     ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF246BFD),
                        Color(0xFF347EFF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF246BFD)
                            .withValues(alpha: 0.28),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  // login button
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              // ... rest of your code unchanged (OR divider, Google button, Sign up row)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final isValid =
        formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    if (rememberMe) {
      await AppStorage.saveLogin();
    } else {
      await AppStorage.clearLogin();
    }

    if (!mounted) {
      return;
    }

    context.go('/home');
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isDarkMode,
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,

      style: TextStyle(
        color: textColor,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),

      cursorColor: const Color(0xFF246BFD),

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: TextStyle(
          color: isDarkMode
              ? const Color(0xFF9CAEC4)
              : const Color(0xFF98A2B3),
          fontSize: 15,
        ),

        prefixIcon: Icon(
          icon,
          color: isDarkMode
              ? const Color(0xFF9CAEC4)
              : const Color(0xFF667085),
        ),

        suffixIcon: suffixIcon,

        filled: true,
        fillColor: cardColor,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF246BFD),
            width: 1.8,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFD92D20),
            width: 1,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFD92D20),
            width: 1.8,
          ),
        ),

        errorStyle: const TextStyle(
          color: Color(0xFFD92D20),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}