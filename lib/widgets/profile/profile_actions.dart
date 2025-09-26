import 'package:flutter/material.dart';

class ProfileActions extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onLogout;

  const ProfileActions({super.key, required this.onDelete, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.delete, color: Colors.red),
          title: const Text("Eliminar cuenta", style: TextStyle(color: Colors.red)),
          onTap: onDelete,
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.white),
          title: const Text("Cerrar sesión", style: TextStyle(color: Colors.white)),
          onTap: onLogout,
        ),
      ],
    );
  }
}
