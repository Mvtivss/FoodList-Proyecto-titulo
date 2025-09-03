import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/kitchen_ingredient.dart';
import 'ingredient_item_widget.dart';

class IngredientGroupWidget extends StatelessWidget {
  final String location;
  final List<KitchenIngredient> ingredients;

  const IngredientGroupWidget({
    super.key,
    required this.location,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildGroupHeader(),
        ...ingredients.map((ingredient) => IngredientItemWidget(ingredient: ingredient)),
      ],
    );
  }

  Widget _buildGroupHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: _getLocationColor(location),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Icon(
            _getLocationIcon(location),
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            location,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${ingredients.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getLocationColor(String location) {
    switch (location) {
      case 'Refrigerador':
        return Colors.blue;
      case 'Despensa':
        return Colors.brown;
      case 'Panera':
        return Colors.orange;
      default:
        return Colors.grey;
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
      default:
        return Icons.home;
    }
  }
}