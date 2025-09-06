// lib/Screens/avatar_selection_screen.dart

import 'package:flutter/material.dart';


// Helper class to organize avatar data
class Avatar {
  final String name;
  final String path;

  const Avatar({required this.name, required this.path});
}

// The widget is now an AlertDialog, not a full screen
class AvatarSelectionDialog extends StatelessWidget {
  const AvatarSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // A list of your custom avatars
    final List<Avatar> avatars = [
      const Avatar(name: 'Beaker', path: 'assets/avatars/avatar1.png'),
      const Avatar(name: 'Atom', path: 'assets/avatars/avatar2.png'),
      const Avatar(name: 'Element', path: 'assets/avatars/avatar3.png'),
      const Avatar(name: 'Scientist', path: 'assets/avatars/avatar4.png'),
      const Avatar(name: 'Atom', path: 'assets/avatars/avatar5.png'),
    ];

    return AlertDialog(
      title: const Text('Choose Your Avatar'),
      backgroundColor: const Color(0xFF112240), // Match the theme
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // --- THIS IS THE FIX ---
      // Using SingleChildScrollView and Wrap to prevent overflow
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 24.0, // Horizontal space between avatars
          runSpacing: 16.0, // Vertical space between rows
          alignment: WrapAlignment.center,
          children: avatars.map((avatar) {
            return InkWell(
              onTap: () {
                Navigator.pop(context, avatar.path);
              },
              borderRadius: BorderRadius.circular(100),
              child: SizedBox(
                width: 70, // Give each item a fixed width
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF0A192F),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(avatar.path),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      avatar.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

