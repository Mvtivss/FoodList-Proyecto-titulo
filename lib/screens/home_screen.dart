import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/kitche_inventory_screen.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/shopping_list_screen.dart';
import 'package:flutter_application_1/widgets/home/home_appbar.dart';
import 'package:flutter_application_1/widgets/home/features_grid_widget.dart';
import 'package:flutter_application_1/widgets/home/home_drawer_widget.dart';
import 'package:flutter_application_1/widgets/home/virtual_assistant_modal.dart';
import 'package:flutter_application_1/widgets/home/home_footer_widget.dart';

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

  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }

  void _initializeAnimations() {
    // Crear controladores de animación para cada botón principal
    _animationControllers = List.generate(
      4,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: this,
      ),
    );

    // Crear animaciones de escala
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

  void _disposeAnimations() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
  }

  Future<void> _onButtonPressed(int index, VoidCallback onPressed) async {
    await _animationControllers[index].forward();
    await _animationControllers[index].reverse();
    onPressed();
  }

  void _showVirtualAssistant() {
    VirtualAssistantModal.show(context);
  }

  void _navigateToShoppingList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ShoppingListScreen()),
    );
  }

  void _navigateToKitchenInventory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const KitchenInventoryScreen()),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: HomeDrawerWidget(
        onKitchenTap: _navigateToKitchenInventory,
        onProfileTap: _navigateToProfile,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: screenHeight * 0.15),
              FeaturesGridWidget(
                animationControllers: _animationControllers,
                scaleAnimations: _scaleAnimations,
                onButtonPressed: _onButtonPressed,
                onShoppingListPressed: _navigateToShoppingList,
                onVirtualAssistantPressed: _showVirtualAssistant,
              ),
              const HomeFooterWidget(),
            ],
          ),
          HomeAppBar(screenWidth: screenWidth, screenHeight: screenHeight),
        ],
      ),
    );
  }
}