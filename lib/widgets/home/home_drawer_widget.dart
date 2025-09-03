import 'package:flutter/material.dart';

class HomeDrawerWidget extends StatelessWidget {
  final VoidCallback onKitchenTap;
  final VoidCallback onProfileTap;

  const HomeDrawerWidget({
    super.key,
    required this.onKitchenTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _DrawerHeader(),
          _buildMainOptions(context),
          const Divider(),
          const _FavoriteRecipesSection(),
        ],
      ),
    );
  }

  Widget _buildMainOptions(BuildContext context) {
    return Column(
      children: [
        _DrawerListTile(
          icon: Icons.kitchen,
          title: 'Tu Cocina',
          backgroundColor: const Color.fromARGB(255, 184, 110, 84),
          onTap: () {
            Navigator.pop(context);
            onKitchenTap();
          },
        ),
        _DrawerListTile(
          icon: Icons.restaurant_menu,
          title: 'Tus Recetas',
          backgroundColor: const Color.fromARGB(255, 117, 64, 45),
          onTap: () {
            Navigator.pop(context);
            // Agregar navegación a la pantalla de recetas
          },
        ),
        _DrawerListTile(
          icon: Icons.person,
          title: 'Perfil',
          backgroundColor: const Color.fromARGB(255, 184, 110, 84),
          onTap: () {
            Navigator.pop(context);
            onProfileTap();
          },
        ),
      ],
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return const DrawerHeader(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 9, 77, 133),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menú Principal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Accesos rápidos',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _DrawerListTile({
    required this.icon,
    required this.title,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}

class _FavoriteRecipesSection extends StatelessWidget {
  const _FavoriteRecipesSection();

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes = [
      'Spaguettis a la Boloñesa',
      'Rissoto de Champiñones',
      'Pastel de Chocolate',
      'Ensalada César',
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Recetas Favoritas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 9, 77, 133),
            ),
          ),
        ),
        ...favoriteRecipes.map((recipe) => ListTile(
          leading: const Icon(Icons.star, color: Colors.yellow),
          title: Text(recipe),
        )),
      ],
    );
  }
}