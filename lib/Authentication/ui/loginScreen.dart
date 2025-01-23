import 'package:flutter/material.dart';
import 'package:recipenest/util/mybutton.dart';
import '../auth_service.dart';

class LoginScreen extends StatefulWidget {
  final void Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variable to track password visibility
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() async {
    //
    final _authService = AuthService();

    try {
      await _authService.signInWithEmailPassword(
          _emailController.text, _passwordController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            
            children: [
              // Background gradient
              Image.asset('assets/icons/logo.png'),
              // Form container
              Padding(
                padding: const EdgeInsets.only(top:100,right: 20,left: 20),
                child:  SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Email field
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.check,
                                color: Colors.grey,
                              ),
                              label: Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F0F0F), // Primary Red
                                ),
                              ),
                            ),
                          ),
                          // Password field with visibility toggle
                          TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible, // Toggle visibility
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              label: const Text(
                                'Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF070707), // Primary Red
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Forgot password
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0xFF795548), // Brown
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),
                          // Sign-in button
                          Mybutton(
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: login,
                              child: Mytext(
                                  fontSize: 20,
                                  text: 'Sign In',
                                  color: Colors.white)),
                          const SizedBox(height: 150),
                          // Center the "Don't have an account?" and "Sign up" link
                          Center(
                            child: Column(
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: widget.onTap,
                                  child: const Text(
                                    "Sign up",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Color(0xFF795548), // Brown
                                    ),
                                  ),
                                ),
                              
                                
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
