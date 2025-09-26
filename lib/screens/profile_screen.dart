import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'package:flutter_application_1/widgets/profile/profile_avatar.dart';
import 'package:flutter_application_1/widgets/profile/profile_form.dart';
import 'package:flutter_application_1/widgets/profile/profile_actions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();

  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user_data');
    if (userString != null) {
      final data = jsonDecode(userString);
      setState(() {
        _userData = data;
        _usernameController.text = data['username'] ?? '';
        _fullNameController.text = data['full_name'] ?? '';
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final result = await ApiService.updateUser(
        userId: _userData?['id'],
        username: _usernameController.text.trim(),
        fullName: _fullNameController.text.trim(),
      );

      if (!mounted) return;

      if (result['success']) {
        final prefs = await SharedPreferences.getInstance();
        final updatedUser = {
          ..._userData!,
          'username': _usernameController.text.trim(),
          'full_name': _fullNameController.text.trim(),
        };
        await prefs.setString('user_data', jsonEncode(updatedUser));

        setState(() {
          _userData = updatedUser;
        });

        _showMessage("Perfil actualizado correctamente", isError: false);
      } else {
        _showMessage(result['error']);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar cuenta"),
        content: const Text(
            "¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context, true),
            child: const Text("Eliminar", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        final result = await ApiService.deleteUser(_userData?['id']);
        if (!mounted) return;

        if (result['success']) {
          _showMessage("Cuenta eliminada", isError: false);
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          _showMessage(result['error']);
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _logout() async {
    await ApiService.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: isError ? Colors.red : Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Perfil"), backgroundColor: const Color(0xFF667eea)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                ProfileAvatar(email: _userData?['email'] ?? ''),
                const SizedBox(height: 32),
                ProfileForm(
                  formKey: _formKey,
                  usernameController: _usernameController,
                  fullNameController: _fullNameController,
                  isLoading: _isLoading,
                  onSave: _updateProfile,
                ),
                const SizedBox(height: 32),
                ProfileActions(onDelete: _deleteAccount, onLogout: _logout),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
