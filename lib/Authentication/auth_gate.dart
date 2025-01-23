import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipenest/Authentication/login_or_register.dart';


import '../pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
       
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

  
        if (snapshot.hasData) {
          print("User is logged in: ${FirebaseAuth.instance.currentUser?.email}");
          return  HomePage(); 
        } else {
           print("No user signed in");
          return LoginOrRegsiter(); 
        }
      },
    );
  }
}
