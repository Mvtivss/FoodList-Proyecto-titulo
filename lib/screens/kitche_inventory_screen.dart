import 'package:flutter/material.dart';
import 'package:flutter_application_1/entities/kitchen_ingredient.dart';

class KitchenInventoryScreen extends StatefulWidget {
  const KitchenInventoryScreen({super.key});

  @override
  State<KitchenInventoryScreen> createState() => _KitchenInventoryScreenState();
}

class _KitchenInventoryScreenState extends State<KitchenInventoryScreen> {
  String selectedFilter = 'Todos';
  final List<String> filterOptions = ['Todos', 'Disponibles', 'Por vencer', 'Vencidos', 'Agotados'];

  @override
  Widget build(BuildContext context) {
    // Obtener los ingredientes usando la función del modelo
    KitchenIngredient kitchenIngredient = KitchenIngredient(name: '', quantity: '', location: '');
    List<KitchenIngredient> allIngredients = kitchenIngredient.getAvailableIngredients();

    // Filtrar ingredientes según la selección
    List<KitchenIngredient> filteredIngredients = _getFilteredIngredients(allIngredients);

    // Agrupar ingredientes por ubicación
    Map<String, List<KitchenIngredient>> ingredientsByLocation = _groupIngredientsByLocation(filteredIngredients);

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        title: const Text(
          'Inventario de Cocina',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 9, 77, 133),
      ),
      body: Column(
        children: [
          // Filtros
          Container(
            margin: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filterOptions.map((filter) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: selectedFilter == filter,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      selectedColor: Colors.green[200],
                      backgroundColor: Colors.grey[200],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Estadísticas rápidas
          _buildQuickStats(allIngredients),
          
          // Lista de ingredientes
          Expanded(
            child: filteredIngredients.isEmpty
                ? Center(
                    child: Text(
                      'No hay ingredientes para mostrar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : ListView(
                    children: ingredientsByLocation.entries.map((entry) {
                      return _buildIngredientGroup(entry.key, entry.value);
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  List<KitchenIngredient> _getFilteredIngredients(List<KitchenIngredient> ingredients) {
    switch (selectedFilter) {
      case 'Disponibles':
        return ingredients.where((ingredient) => ingredient.isAvailable && !ingredient.isExpired()).toList();
      case 'Por vencer':
        return ingredients.where((ingredient) => ingredient.isExpiringSoon(3)).toList();
      case 'Vencidos':
        return ingredients.where((ingredient) => ingredient.isExpired()).toList();
      case 'Agotados':
        return ingredients.where((ingredient) => !ingredient.isAvailable).toList();
      default:
        return ingredients;
    }
  }

  Map<String, List<KitchenIngredient>> _groupIngredientsByLocation(List<KitchenIngredient> ingredients) {
    Map<String, List<KitchenIngredient>> ingredientsByLocation = {};

    for (var ingredient in ingredients) {
      if (!ingredientsByLocation.containsKey(ingredient.location)) {
        ingredientsByLocation[ingredient.location] = [];
      }
      ingredientsByLocation[ingredient.location]!.add(ingredient);
    }

    return ingredientsByLocation;
  }

  Widget _buildQuickStats(List<KitchenIngredient> allIngredients) {
    int disponibles = allIngredients.where((i) => i.isAvailable && !i.isExpired()).length;
    int porVencer = allIngredients.where((i) => i.isExpiringSoon(3)).length;
    int vencidos = allIngredients.where((i) => i.isExpired()).length;
    int agotados = allIngredients.where((i) => !i.isAvailable).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('Disponibles', disponibles, Colors.green)),
          const SizedBox(width: 8),
          Expanded(child: _buildStatCard('Por vencer', porVencer, Colors.orange)),
          const SizedBox(width: 8),
          Expanded(child: _buildStatCard('Vencidos', vencidos, Colors.red)),
          const SizedBox(width: 8),
          Expanded(child: _buildStatCard('Agotados', agotados, Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color) {
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

  Widget _buildIngredientGroup(String location, List<KitchenIngredient> ingredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
        ),
        ...ingredients.map((ingredient) => _buildIngredientItem(ingredient)),
      ],
    );
  }

  Widget _buildIngredientItem(KitchenIngredient ingredient) {
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
            child: Column(
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
            ),
          ),
          Container(
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