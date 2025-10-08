


import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/kitchen_ingredient.dart';
import 'ingredient_item_widget.dart';

class IngredientGroupWidget extends StatelessWidget {
  final String location;
  final List<KitchenIngredient> ingredients;
  final Function(String)? onRemoveIngredient;
  final Function(KitchenIngredient)? onEditIngredient;

  const IngredientGroupWidget({
    super.key,
    required this.location,
    required this.ingredients,
    this.onRemoveIngredient,
    this.onEditIngredient,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildGroupHeader(),
        ...ingredients.map(
          (ingredient) => IngredientItemWidget(
            ingredient: ingredient,
            onRemove: onRemoveIngredient,
            onEdit: onEditIngredient,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildGroupHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: _getLocationColor(location),
        shadows: [
          BoxShadow(
            color: _getLocationColor(location).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getLocationIcon(location),
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              location,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.inventory_2,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  '${ingredients.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getLocationColor(String location) {
    switch (location) {
      case 'Refrigerador':
        return const Color(0xFF2196F3); // Azul
      case 'Despensa':
        return const Color(0xFF795548); // Marrón
      case 'Panera':
        return const Color(0xFFFF9800); // Naranja
      case 'Congelador':
        return const Color(0xFF00BCD4); // Cyan
      default:
        return const Color(0xFF9E9E9E); // Gris
    }
  }

  IconData _getLocationIcon(String location) {
    switch (location) {
      case 'Refrigerador':
        return Icons.kitchen;
      case 'Despensa':
        return Icons.inventory_2;
      case 'Panera':
        return Icons.bakery_dining;
      case 'Congelador':
        return Icons.ac_unit;
      default:
        return Icons.home;
    }
  }
}

