import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/kitchen_ingredient.dart';

class ShoppingListItem extends StatelessWidget {
  final KitchenIngredient ingredient;
  final bool isSelected;
  final Function(KitchenIngredient) onToggle;

  const ShoppingListItem({
    super.key,
    required this.ingredient,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context).scale(1);
    final screenWidth = MediaQuery.of(context).size.width;
    Color reasonColor = _getReasonColor();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: screenWidth * 0.01),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(reasonColor, textScaler),
          _buildContent(reasonColor, textScaler),
        ],
      ),
    );
  }

  Widget _buildHeader(Color reasonColor, double textScaler) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: reasonColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getLocationIcon(ingredient.location),
            size: 16,
            color: reasonColor,
          ),
          const SizedBox(width: 4),
          Text(
            ingredient.location,
            style: TextStyle(
              fontSize: 10 * textScaler,
              fontWeight: FontWeight.bold,
              color: reasonColor,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: reasonColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getReasonToBuy(),
              style: TextStyle(
                fontSize: 8 * textScaler,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Color reasonColor, double textScaler) {
    return ListTile(
      leading: Icon(
        _getReasonIcon(),
        color: reasonColor,
        size: 28,
      ),
      title: Text(
        ingredient.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10 * textScaler,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cantidad sugerida: ${ingredient.quantity}',
            style: TextStyle(fontSize: 8 * textScaler),
          ),
          if (ingredient.expirationDate != null)
            Text(
              'Última fecha: ${_formatDate(ingredient.expirationDate!)}',
              style: TextStyle(
                fontSize: 8 * textScaler,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
      trailing: Checkbox(
        value: isSelected,
        onChanged: (bool? value) => onToggle(ingredient),
        activeColor: Colors.green,
      ),
      onTap: () => onToggle(ingredient),
    );
  }

  String _getReasonToBuy() {
    if (!ingredient.isAvailable) {
      return 'Agotado';
    } else if (ingredient.isExpired()) {
      return 'Vencido';
    } else if (ingredient.isExpiringSoon(3)) {
      return 'Por vencer';
    } else if (ingredient.quantity.contains('0')) {
      return 'Sin stock';
    }
    return 'Necesario';
  }

  Color _getReasonColor() {
    if (!ingredient.isAvailable || ingredient.quantity.contains('0')) {
      return Colors.red;
    } else if (ingredient.isExpired()) {
      return Colors.red[700]!;
    } else if (ingredient.isExpiringSoon(3)) {
      return Colors.orange;
    }
    return Colors.blue;
  }

  IconData _getReasonIcon() {
    if (!ingredient.isAvailable || ingredient.quantity.contains('0')) {
      return Icons.remove_shopping_cart;
    } else if (ingredient.isExpired()) {
      return Icons.dangerous;
    } else if (ingredient.isExpiringSoon(3)) {
      return Icons.warning;
    }
    return Icons.add_shopping_cart;
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}