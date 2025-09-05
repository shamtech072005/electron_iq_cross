// lib/Widgets/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/auth_service.dart';
import '../Screens/premium_screen.dart';
import '../Screens/avatar_selection_screen.dart';
import '../Screens/about_us_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _avatarPath = 'assets/avatars/avatar1.png'; // Default avatar

  @override
  void initState() {
    super.initState();
    _loadAvatarPath();
  }

  // Load the saved avatar path from local storage
  Future<void> _loadAvatarPath() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
       setState(() {
        _avatarPath = prefs.getString('user_avatar') ?? 'assets/avatars/avatar1.png';
      });
    }
  }

  // Save the new avatar path to local storage
  Future<void> _saveAvatarPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_avatar', path);
  }

  // Show the avatar selection dialog and handle the result
  void _changeAvatar() async {
    final selectedAvatar = await showDialog<String>(
      context: context,
      builder: (context) => const AvatarSelectionDialog(),
    );

    if (selectedAvatar != null) {
      await _saveAvatarPath(selectedAvatar); // Save the new choice
      _loadAvatarPath(); // Reload to update the UI instantly
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? 'Guest User';
    
    // Refresh the avatar every time the drawer is built to ensure it's up-to-date
    _loadAvatarPath();

    return Drawer(
      backgroundColor: const Color(0xFF0A192F),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF112240),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: _changeAvatar,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(_avatarPath),
                          ),
                        ),
                      ),
                      const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.tealAccent,
                        child: Icon(Icons.edit, size: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(displayName, style: const TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium_rounded, color: Colors.tealAccent),
            title: const Text('Go Premium'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PremiumScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded, color: Colors.white70),
            title: const Text('About Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsScreen()),
              );
            },
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.white70),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              AuthService().signOut();
            },
          ),
        ],
      ),
    );
  }
}

