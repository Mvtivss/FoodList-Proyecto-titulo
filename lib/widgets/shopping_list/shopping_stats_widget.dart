import 'package:flutter/material.dart';

class ShoppingStatsWidget extends StatelessWidget {
  final int totalItems;
  final int selectedCount;

  const ShoppingStatsWidget({
    super.key,
    required this.totalItems,
    required this.selectedCount,
  });

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context).scale(1);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTotalItemsInfo(textScaler),
          _buildSelectedItemsBadge(textScaler),
        ],
      ),
    );
  }

  Widget _buildTotalItemsInfo(double textScaler) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredientes necesarios',
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 12 * textScaler,
          ),
        ),
        Text(
          '$totalItems productos',
          style: TextStyle(
            fontSize: 10 * textScaler,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedItemsBadge(double textScaler) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Seleccionados: $selectedCount',
        style: TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 10 * textScaler,
          color: Colors.green[800],
        ),
      ),
    );
  }
}