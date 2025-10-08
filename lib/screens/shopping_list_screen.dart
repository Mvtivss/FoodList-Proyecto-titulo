/*import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/kitchen_ingredient.dart';
import 'package:flutter_application_1/widgets/shopping_list/shopping_stats_widget.dart';
import 'package:flutter_application_1/widgets/shopping_list/search_ingredient_bar.dart';
import 'package:flutter_application_1/widgets/shopping_list/shopping_list_item.dart';
import 'package:flutter_application_1/widgets/shopping_list/empty_shopping_list_widget.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ShoppingListScreenState createState() => ShoppingListScreenState();
}

class ShoppingListScreenState extends State<ShoppingListScreen> {
  TextEditingController searchController = TextEditingController();

  // Lista de ingredientes que necesitamos comprar (los que están agotados o por vencer)
  late List<KitchenIngredient> shoppingList;
  late List<KitchenIngredient> filteredShoppingList;

  // Ingredientes seleccionados para comprar
  Map<String, bool> selectedItems = {};

  @override
  void initState() {
    super.initState();
    _initializeShoppingList();
  }

  void _initializeShoppingList() {
    // Crear una instancia para acceder a los métodos
    List<KitchenIngredient> allIngredients = KitchenIngredient.getAvailableIngredients();
    
    // Filtrar ingredientes que necesitamos comprar (agotados, vencidos o por vencer)
    shoppingList = allIngredients.where((ingredient) =>
        !ingredient.isAvailable || 
        ingredient.isExpired() || 
        ingredient.isExpiringSoon(3) ||
        ingredient.quantity.contains('0')).toList();
    
    filteredShoppingList = shoppingList;
    
    // Inicializar el mapa de selección
    selectedItems = {
      for (var ingredient in shoppingList) ingredient.name: false,
    };
  }

  void _toggleItemSelection(KitchenIngredient ingredient) {
    setState(() {
      selectedItems[ingredient.name] = !selectedItems[ingredient.name]!;
    });
  }

  void _filterShoppingList(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        filteredShoppingList = shoppingList;
      } else {
        filteredShoppingList = shoppingList
            .where((ingredient) =>
                ingredient.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
                ingredient.location.toLowerCase().contains(searchTerm.toLowerCase()))
            .toList();
      }
    });
  }

  void _handleGoToShopping() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Lista para comprar $selectedCount ingredientes!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  int get selectedCount => selectedItems.values.where((selected) => selected).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Estadísticas de compras
          ShoppingStatsWidget(
            totalItems: filteredShoppingList.length,
            selectedCount: selectedCount,
          ),
          
          // Barra de búsqueda
          SearchIngredientBar(
            controller: searchController,
            onChanged: _filterShoppingList,
          ),
          
          const SizedBox(height: 10),
          
          // Lista de ingredientes
          Expanded(
            child: _buildShoppingList(),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      title: const Text(
        'Lista de Compras',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color.fromARGB(255, 9, 77, 133),
    );
  }

  Widget _buildShoppingList() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: filteredShoppingList.isEmpty
          ? const EmptyShoppingListWidget()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: filteredShoppingList.map((ingredient) {
                return ShoppingListItem(
                  ingredient: ingredient,
                  isSelected: selectedItems[ingredient.name]!,
                  onToggle: _toggleItemSelection,
                );
              }).toList(),
            ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (selectedCount <= 0) return null;
    
    return FloatingActionButton.extended(
      onPressed: _handleGoToShopping,
      label: Text('Ir a comprar ($selectedCount)'),
      icon: const Icon(Icons.shopping_cart),
      backgroundColor: Colors.green,
    );
  }
}*/


import 'package:flutter/material.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pantalla Básica"),
      ),
      body: const Center(
        child: Text(
          "Hola",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
