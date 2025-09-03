import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/kitchen_ingredient.dart';

class IngredientItemWidget extends StatelessWidget {
  final KitchenIngredient ingredient;

  const IngredientItemWidget({
    super.key,
    required this.ingredient,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = _getIngredientStatusColor(ingredient);
    String statusText = _getIngredientStatusText(ingredient);
    IconData statusIcon = _getIngredientStatusIcon(ingredient);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: statusColor.withOpacity(0.1),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildIngredientInfo(statusColor),
          ),
          _buildStatusBadge(statusText, statusColor),
        ],
      ),
    );
  }

  Widget _buildIngredientInfo(Color statusColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ingredient.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Cantidad: ${ingredient.quantity}',
          style: const TextStyle(fontSize: 14),
        ),
        if (ingredient.expirationDate != null)
          Text(
            'Vence: ${_formatDate(ingredient.expirationDate!)}',
            style: TextStyle(
              fontSize: 12,
              color: statusColor,
            ),
          ),
      ],
    );
  }

  Widget _buildStatusBadge(String statusText, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getIngredientStatusColor(KitchenIngredient ingredient) {
    if (ingredient.isExpired()) {
      return Colors.red;
    } else if (!ingredient.isAvailable) {
      return Colors.grey;
    } else if (ingredient.isExpiringSoon(3)) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  String _getIngredientStatusText(KitchenIngredient ingredient) {
    if (ingredient.isExpired()) {
      return 'Vencido';
    } else if (!ingredient.isAvailable) {
      return 'Agotado';
    } else if (ingredient.isExpiringSoon(3)) {
      return 'Por vencer';
    } else {
      return 'Disponible';
    }
  }

  IconData _getIngredientStatusIcon(KitchenIngredient ingredient) {
    if (ingredient.isExpired()) {
      return Icons.dangerous;
    } else if (!ingredient.isAvailable) {
      return Icons.remove_circle;
    } else if (ingredient.isExpiringSoon(3)) {
      return Icons.warning;
    } else {
      return Icons.check_circle;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}