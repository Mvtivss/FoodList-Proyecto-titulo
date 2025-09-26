import 'package:flutter/material.dart';
import 'profile_input_field.dart';

class ProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController fullNameController;
  final bool isLoading;
  final VoidCallback onSave;

  const ProfileForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.fullNameController,
    required this.isLoading,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          ProfileInputField(
            controller: usernameController,
            label: "Nombre de usuario",
            icon: Icons.account_circle,
            validator: (v) => v == null || v.isEmpty ? "Requerido" : null,
          ),
          const SizedBox(height: 20),
          ProfileInputField(
            controller: fullNameController,
            label: "Nombre completo",
            icon: Icons.person,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF667eea),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Guardar cambios",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
