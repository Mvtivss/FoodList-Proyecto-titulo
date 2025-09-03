import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/kitchen_ingredient.dart';
import 'package:flutter_application_1/widgets/kitchen_invetory/filter_chips_widget.dart';
import 'package:flutter_application_1/widgets/kitchen_invetory/quick_stats_widget.dart';
import 'package:flutter_application_1/widgets/kitchen_invetory/ingredient_group_widget.dart';

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
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Filtros
          FilterChipsWidget(
            filterOptions: filterOptions,
            selectedFilter: selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                selectedFilter = filter;
              });
            },
          ),
          
          // Estadísticas rápidas
          QuickStatsWidget(ingredients: allIngredients),
          
          // Lista de ingredientes
          Expanded(
            child: _buildIngredientsList(filteredIngredients, ingredientsByLocation),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      title: const Text(
        'Inventario de Cocina',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color.fromARGB(255, 9, 77, 133),
    );
  }

  Widget _buildIngredientsList(
    List<KitchenIngredient> filteredIngredients,
    Map<String, List<KitchenIngredient>> ingredientsByLocation,
  ) {
    if (filteredIngredients.isEmpty) {
      return Center(
        child: Text(
          'No hay ingredientes para mostrar',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView(
      children: ingredientsByLocation.entries.map((entry) {
        return IngredientGroupWidget(
          location: entry.key,
          ingredients: entry.value,
        );
      }).toList(),
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
}