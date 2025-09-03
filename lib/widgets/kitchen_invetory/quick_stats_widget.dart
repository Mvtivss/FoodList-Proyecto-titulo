import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/kitchen_ingredient.dart';

class QuickStatsWidget extends StatelessWidget {
  final List<KitchenIngredient> ingredients;

  const QuickStatsWidget({
    super.key,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    int disponibles = ingredients.where((i) => i.isAvailable && !i.isExpired()).length;
    int porVencer = ingredients.where((i) => i.isExpiringSoon(3)).length;
    int vencidos = ingredients.where((i) => i.isExpired()).length;
    int agotados = ingredients.where((i) => !i.isAvailable).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _StatCard(title: 'Disponibles', count: disponibles, color: Colors.green)),
          const SizedBox(width: 8),
          Expanded(child: _StatCard(title: 'Por vencer', count: porVencer, color: Colors.orange)),
          const SizedBox(width: 8),
          Expanded(child: _StatCard(title: 'Vencidos', count: vencidos, color: Colors.red)),
          const SizedBox(width: 8),
          Expanded(child: _StatCard(title: 'Agotados', count: agotados, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}