
import 'package:electron_iq/Screens/login_screen.dart';
import 'package:electron_iq/Screens/main_menu_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Services/auth_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().user,
      builder: (context, snapshot) {
        // If the snapshot is still waiting, show a loading indicator
        if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If user is not logged in, show LoginScreen
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // If user is logged in, show MainMenuScreen
        return const MainMenuScreen();
      },
    );
  }
}
