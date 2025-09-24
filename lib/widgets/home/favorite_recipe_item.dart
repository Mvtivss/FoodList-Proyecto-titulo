import 'package:flutter/material.dart';

class FavoriteRecipeItem extends StatelessWidget {
  const FavoriteRecipeItem({
    super.key,
    required this.recipeName,
    required this.icon,
  });

  final String recipeName;
  final IconData icon;

  static const List<Color> recipeColors = [
    Color(0xFFFF9A56), // Naranja suave
    Color(0xFF6C63FF), // Púrpura vibrante
    Color(0xFF2ED573), // Verde esmeralda
  ];

  @override
  Widget build(BuildContext context) {
    // Usar el hash del nombre para obtener un color consistente
    final colorIndex = recipeName.hashCode.abs() % recipeColors.length;
    final color = recipeColors[colorIndex];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        title: Text(
          recipeName,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2D3436),
            shadows: [
              Shadow(
                color: color.withOpacity(0.1),
                offset: const Offset(0.5, 0.5),
                blurRadius: 1,
              ),
            ],
          ),
        ),
        trailing: Icon(
          Icons.favorite,
          size: 18,
          color: color.withOpacity(0.7),
        ),
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {
          // Aquí podrías navegar a los detalles de la receta
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Abriendo receta: $recipeName'),
              backgroundColor: color,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }
}