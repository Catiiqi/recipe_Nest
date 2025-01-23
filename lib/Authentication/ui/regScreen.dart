import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
// import 'package:recipenest/pages/home_page.dart';
import '../../util/mybutton.dart';
import '../auth_service.dart';


class RegScreen extends StatefulWidget {
  final void Function()? onTap;
  const RegScreen({super.key, required this.onTap});

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  // Variables to track password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confrmPasswordController = TextEditingController();
  final _userFullname = TextEditingController();

  void register() async {
    final _authService = AuthService();
    if (_passwordController.text == _confrmPasswordController.text) {
      try {
        
        await _authService.signUpWithEmailPassword(_emailController.text,
            _passwordController.text,_userFullname.text);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Passowrd Dont match!"),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Lottie.asset("assets/animation/Animation1.json"),
            // Background gradient

            // Form container
            Padding(
              padding: const EdgeInsets.only(top: 100.0, left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Full Name field
                    TextField(
                      controller: _userFullname,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.check,
                          color: Colors.grey,
                        ),
                        label: Text(
                          'Full Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF141414), // Red
                          ),
                        ),
                      ),
                    ),
                    // Email/Phone field
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.check,
                          color: Colors.grey,
                        ),
                        label: Text(
                          ' Gmail',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF141414), // Red
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
                            color: Color(0xFF141414), // Red
                          ),
                        ),
                      ),
                    ),
                    // Confirm Password field with visibility toggle
                    TextField(
                      controller: _confrmPasswordController,
                      obscureText:
                          !_isConfirmPasswordVisible, // Toggle visibility
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                        label: const Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF141414), // Red
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 70),
                    // Sign-up button
                    Mybutton(
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: register,
                        child: Mytext(
                            fontSize: 20,
                            text: 'Sign Up',
                            color: Colors.white)),
                    const SizedBox(height: 80),
                    // Center the "Already have an account?" and "Sign IN" link
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              "Sign IN",
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
    );
  }
}
