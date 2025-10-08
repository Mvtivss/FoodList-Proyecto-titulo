import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/kitchen_ingredient.dart';

class IngredientItemWidget extends StatelessWidget {
  final KitchenIngredient ingredient;
  final Function(String)? onRemove;
  final Function(KitchenIngredient)? onEdit;

  const IngredientItemWidget({
    super.key,
    required this.ingredient,
    this.onRemove,
    this.onEdit,
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
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onEdit != null ? () => onEdit!(ingredient) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  statusIcon,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildIngredientInfo(statusColor)),
              _buildStatusBadge(statusText, statusColor),
              if (onEdit != null || onRemove != null) ...[
                const SizedBox(width: 8),
                _buildActionButtons(context),
              ],
            ],
          ),
        ),
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.scale, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              ingredient.quantity,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        if (ingredient.expirationDate != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: statusColor,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Vence: ${_formatDate(ingredient.expirationDate!)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (ingredient.isExpiringSoon(3) && !ingredient.isExpired()) ...[
                const SizedBox(width: 4),
                Text(
                  '(${_getDaysUntilExpiration()} días)',
                  style: TextStyle(
                    fontSize: 11,
                    color: statusColor,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStatusBadge(String statusText, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        statusText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            color: Colors.blue,
            tooltip: 'Editar',
            onPressed: () => onEdit!(ingredient),
          ),
        if (onRemove != null)
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            color: Colors.red,
            tooltip: 'Eliminar',
            onPressed: () => onRemove!(ingredient.name),
          ),
      ],
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
      return 'VENCIDO';
    } else if (!ingredient.isAvailable) {
      return 'AGOTADO';
    } else if (ingredient.isExpiringSoon(3)) {
      return 'POR VENCER';
    } else {
      return 'DISPONIBLE';
    }
  }

  IconData _getIngredientStatusIcon(KitchenIngredient ingredient) {
    if (ingredient.isExpired()) {
      return Icons.dangerous;
    } else if (!ingredient.isAvailable) {
      return Icons.remove_circle;
    } else if (ingredient.isExpiringSoon(3)) {
      return Icons.warning_amber_rounded;
    } else {
      return Icons.check_circle;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  int _getDaysUntilExpiration() {
    if (ingredient.expirationDate == null) return 0;
    return ingredient.expirationDate!.difference(DateTime.now()).inDays;
  }
}