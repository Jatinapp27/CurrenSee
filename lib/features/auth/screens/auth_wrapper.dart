import 'package:currensee_pkr/data/services/auth_service.dart';
import 'package:currensee_pkr/features/auth/screens/login_screen.dart';
import 'package:currensee_pkr/features/home/screens/home_screen.dart';
import 'package:currensee_pkr/shared_widgets/loading_spinner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  AuthWrapper({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const HomeScreen(); // User is logged in
        } else {
          return const LoginScreen(); // User is logged out
        }
      },
    );
  }
}
