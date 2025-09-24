// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
//import 'package:flutter_application_1/screens/kitche_inventory_screen.dart';
//import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/shopping_list_screen.dart';
import 'package:flutter_application_1/screens/recommended_recipes_screen.dart';
import 'package:flutter_application_1/screens/schedule_screen.dart';
//import 'package:flutter_application_1/screens/your_recipe_screen.dart';
import 'package:flutter_application_1/widgets/home/custom_app_bar.dart';
import 'package:flutter_application_1/widgets/home/custom_drawer.dart';
import 'package:flutter_application_1/widgets/home/features_grid.dart';
import 'package:flutter_application_1/widgets/home/virtual_assistant_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      4,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: this,
      ),
    );

    _scaleAnimations = _animationControllers
        .map((controller) => Tween<double>(
              begin: 1.0,
              end: 0.95,
            ).animate(CurvedAnimation(
              parent: controller,
              curve: Curves.easeInOut,
            )))
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onButtonPressed(int index, VoidCallback onPressed) async {
    await _animationControllers[index].forward();
    await _animationControllers[index].reverse();
    onPressed();
  }

  List<Map<String, dynamic>> _getFeatures() {
    return [
      {
        'label': 'Lista de Compras',
        'icon': Icons.list,
        'onPressed': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShoppingListScreen()),
        ),
      },
      {
        'label': 'Recetas recomendadas',
        'icon': Icons.restaurant,
        'onPressed': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RecommendedRecipesScreen()),
        ),
      },
      {
        'label': 'Horario',
        'icon': Icons.schedule,
        'onPressed': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ScheduleScreen()),
        ),
      },
      {
        'label': 'Recomendaciones',
        'icon': Icons.recommend,
        'onPressed': () => VirtualAssistantModal.show(context),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: screenHeight * 0.10),
              FeaturesGrid(
                features: _getFeatures(),
                animationControllers: _animationControllers,
                scaleAnimations: _scaleAnimations,
                onButtonPressed: _onButtonPressed,
              ),
              _buildFooter(),
            ],
          ),
          CustomAppBar(screenWidth: screenWidth, screenHeight: screenHeight),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF6C63FF), // Púrpura vibrante
              Color(0xFF4ECDC4), // Turquesa brillante
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        width: double.infinity,
        child: const Text(
          'Crea el horario que más te acomode',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}