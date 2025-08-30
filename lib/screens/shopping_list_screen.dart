import 'package:flutter/material.dart';
import 'package:flutter_application_1/entities/kitchen_ingredient.dart';

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

  @override
  void initState() {
    super.initState();
    
    // Crear una instancia para acceder a los métodos
    KitchenIngredient kitchenHelper = KitchenIngredient(name: '', quantity: '', location: '');
    List<KitchenIngredient> allIngredients = kitchenHelper.getAvailableIngredients();
    
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

  int get selectedCount => selectedItems.values.where((selected) => selected).length;

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context).scale(1);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        title: const Text(
          'Lista de Compras',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 9, 77, 133),
      ),
      body: Column(
        children: [
          // Estadísticas de compras
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                      '${filteredShoppingList.length} productos',
                      style: TextStyle(
                        fontSize: 10 * textScaler,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Container(
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
                ),
              ],
            ),
          ),
          
          // Barra de búsqueda
          SearchIngredientBar(
            controller: searchController,
            onChanged: _filterShoppingList,
          ),
          
          const SizedBox(height: 10),
          
          // Lista de ingredientes
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: filteredShoppingList.isEmpty
                  ? Center(
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
                    )
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
            ),
          ),
        ],
      ),
      floatingActionButton: selectedCount > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                // Aquí podrías implementar la lógica para ir a comprar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('¡Lista para comprar $selectedCount ingredientes!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              label: Text('Ir a comprar ($selectedCount)'),
              icon: const Icon(Icons.shopping_cart),
              backgroundColor: Colors.green,
            )
          : null,
    );
  }
}

class SearchIngredientBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchIngredientBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScaler = MediaQuery.textScalerOf(context).scale(1);
    
    return SearchBar(
      controller: controller,
      onChanged: onChanged,
      constraints: BoxConstraints.expand(height: 40, width: screenWidth * 0.9),
      hintStyle: WidgetStatePropertyAll(TextStyle(fontSize: 8 * textScaler)),
      hintText: 'Buscar ingrediente o ubicación',
      backgroundColor: WidgetStatePropertyAll(Colors.grey[300]),
      elevation: const WidgetStatePropertyAll(0),
      leading: const Icon(Icons.search),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }
}

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
          // Header con ubicación y motivo
          Container(
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
          ),
          
          // Contenido principal
          ListTile(
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
          ),
        ],
      ),
    );
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