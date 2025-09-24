import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/kitche_inventory_screen.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/schedule_screen.dart';
import 'package:flutter_application_1/screens/your_recipe_screen.dart';
import 'drawer_item.dart';
import 'favorite_recipe_item.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8F9FA), // Blanco suave
              Color(0xFFE9ECEF), // Gris muy claro
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(),
            const SizedBox(height: 10),
            ..._buildMainOptions(context),
            const Divider(
              color: Color(0xFF4ECDC4),
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
            _buildFavoriteRecipesSection(),
            const SizedBox(height: 20),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF667eea), // Azul elegante
            Color(0xFF764ba2), // Púrpura sofisticado
            Color(0xFF4ECDC4), // Turquesa vibrante
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 15,
          ),
        ],
      ),
      child: DrawerHeader(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'FOODLIST',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Tu asistente de cocina inteligente',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Accesos rápidos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMainOptions(BuildContext context) {
    final options = [
      {
        'title': 'Tu Cocina',
        'icon': Icons.kitchen,
        'color': const Color(0xFFFF6B6B),
        'onTap': () => _navigateTo(context, const KitchenInventoryScreen()),
      },
      {
        'title': 'Tus Recetas',
        'icon': Icons.restaurant_menu,
        'color': const Color(0xFF4ECDC4),
        'onTap': () => _navigateTo(context, const YourRecipesScreen()),
      },
      {
        'title': 'Horario de Comidas',
        'icon': Icons.schedule,
        'color': const Color(0xFFFFBE0B),
        'onTap': () => _navigateTo(context, const ScheduleScreen()),
      },
      {
        'title': 'Perfil',
        'icon': Icons.person,
        'color': const Color(0xFF8B5CF6),
        'onTap': () => _navigateTo(context, const ProfileScreen()),
      },
    ];

    return options.map((option) {
      return DrawerItem(
        title: option['title'] as String,
        icon: option['icon'] as IconData,
        color: option['color'] as Color,
        onTap: option['onTap'] as VoidCallback,
      );
    }).toList();
  }

  Widget _buildFavoriteRecipesSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD93D), Color(0xFF6BCF7F)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Recetas Favoritas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
        ),
        const FavoriteRecipeItem(
          recipeName: 'Spaguettis a la Boloñesa',
          icon: Icons.restaurant,
        ),
        const FavoriteRecipeItem(
          recipeName: 'Risotto de Champiñones',
          icon: Icons.rice_bowl,
        ),
        const FavoriteRecipeItem(
          recipeName: 'Pastel de Chocolate',
          icon: Icons.cake,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF74B9FF), // Azul claro
            Color(0xFF0984E3), // Azul vibrante
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF74B9FF).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb,
              color: Colors.yellow,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Organiza mejor tu cocina con FOODLIST',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}