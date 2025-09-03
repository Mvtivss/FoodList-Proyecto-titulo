import 'package:flutter/material.dart';

class EmptyShoppingListWidget extends StatelessWidget {
  const EmptyShoppingListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.green[300],
          ),
          const SizedBox(height: 16),
          Text(
            '¡Tu cocina está bien surtida!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No hay ingredientes que necesiten reposición',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}