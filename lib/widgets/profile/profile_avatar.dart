import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String email;
  const ProfileAvatar({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(email, style: const TextStyle(color: Colors.white70, fontSize: 16)),
      ],
    );
  }
}
