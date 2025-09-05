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
      content: SizedBox(
        width: 450,
        height: 150,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: avatars.length,
          itemBuilder: (context, index) {
            final avatar = avatars[index];
            return InkWell(
              onTap: () {
                Navigator.pop(context, avatar.path);
              },
              borderRadius: BorderRadius.circular(100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- THIS IS THE FIX ---
                  // Use a Container with a circular decoration to properly clip the image
                  Container(
                    width: 70, // Corresponds to radius: 35
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF0A192F),
                      image: DecorationImage(
                        fit: BoxFit.cover, // This crops and centers the image
                        image: AssetImage(avatar.path),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    avatar.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            );
          },
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

