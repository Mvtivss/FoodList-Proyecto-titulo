import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/kitchen_ingredient.dart';

class ExpiringIngredientsBanner extends StatelessWidget {
  final List<KitchenIngredient> ingredients;
  final VoidCallback? onTap;

  const ExpiringIngredientsBanner({
    super.key,
    required this.ingredients,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final expiredCount = ingredients.where((i) => i.isExpired()).length;
    final expiringCount = ingredients.where((i) => i.isExpiringSoon(3) && !i.isExpired()).length;

    if (expiredCount == 0 && expiringCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          if (expiredCount > 0) _buildExpiredBanner(expiredCount, context),
          if (expiredCount > 0 && expiringCount > 0) const SizedBox(height: 8),
          if (expiringCount > 0) _buildExpiringBanner(expiringCount, context),
        ],
      ),
    );
  }

  Widget _buildExpiredBanner(int count, BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red[700]!, Colors.red[500]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.dangerous,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Alimentos Vencidos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    count == 1
                        ? '1 ingrediente ha vencido'
                        : '$count ingredientes han vencido',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiringBanner(int count, BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange[700]!, Colors.orange[500]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Por Vencer Pronto',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    count == 1
                        ? '1 ingrediente vence en los próximos 3 días'
                        : '$count ingredientes vencen en los próximos 3 días',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class ExpiringIngredientsDialog extends StatelessWidget {
  final List<KitchenIngredient> ingredients;
  final Function(String)? onRemove;

  const ExpiringIngredientsDialog({
    super.key,
    required this.ingredients,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final expired = ingredients.where((i) => i.isExpired()).toList();
    final expiring = ingredients
        .where((i) => i.isExpiringSoon(3) && !i.isExpired())
        .toList();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.notification_important, color: Colors.orange),
          SizedBox(width: 12),
          Text('Alertas de Vencimiento'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (expired.isNotEmpty) ...[
              const Text(
                'Vencidos:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              ...expired.map((ing) => _buildIngredientTile(
                    ing,
                    Colors.red,
                    Icons.dangerous,
                    context,
                  )),
              const SizedBox(height: 16),
            ],
            if (expiring.isNotEmpty) ...[
              const Text(
                'Por vencer:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 8),
              ...expiring.map((ing) => _buildIngredientTile(
                    ing,
                    Colors.orange,
                    Icons.warning_amber,
                    context,
                  )),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
        if (expired.isNotEmpty)
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showRemoveExpiredDialog(context, expired);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar Vencidos'),
          ),
      ],
    );
  }

  Widget _buildIngredientTile(
    KitchenIngredient ingredient,
    Color color,
    IconData icon,
    BuildContext context,
  ) {
    final daysUntilExpiration = ingredient.expirationDate!
        .difference(DateTime.now())
        .inDays;

    String subtitle;
    if (daysUntilExpiration < 0) {
      subtitle = 'Venció hace ${-daysUntilExpiration} días';
    } else if (daysUntilExpiration == 0) {
      subtitle = 'Vence HOY';
    } else {
      subtitle = 'Vence en $daysUntilExpiration días';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              color: Colors.red,
              onPressed: () {
                Navigator.pop(context);
                onRemove!(ingredient.name);
              },
            ),
        ],
      ),
    );
  }

  void _showRemoveExpiredDialog(
    BuildContext context,
    List<KitchenIngredient> expired,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Vencidos'),
        content: Text(
          '¿Deseas eliminar los ${expired.length} ingredientes vencidos?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              for (var ing in expired) {
                onRemove?.call(ing.name);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar Todos'),
          ),
        ],
      ),
    );
  }
}