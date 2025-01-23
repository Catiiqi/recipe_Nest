import 'package:flutter/material.dart';
import 'package:recipenest/Authentication/ui/loginScreen.dart';
import 'package:recipenest/Authentication/ui/regScreen.dart';

class LoginOrRegsiter extends StatefulWidget {
  const LoginOrRegsiter({super.key});

  @override
  State<LoginOrRegsiter> createState() => _LoginOrRegsiterState();
}

class _LoginOrRegsiterState extends State<LoginOrRegsiter> {
  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage)
    {
      return LoginScreen(onTap: togglePages);
    }else
    {
      return RegScreen(onTap: togglePages);
    }
  }
}