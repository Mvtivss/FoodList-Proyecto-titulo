// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/kitchen_ingredient.dart';

class RecommendedRecipesScreen extends StatefulWidget {
  const RecommendedRecipesScreen({super.key});

  @override
  State<RecommendedRecipesScreen> createState() => _RecommendedRecipesScreenState();
}

class _RecommendedRecipesScreenState extends State<RecommendedRecipesScreen> {
  String selectedFilter = 'Todas';
  final List<String> filterOptions = ['Todas', 'Con ingredientes disponibles', 'Fáciles', 'Rápidas', 'Favoritas'];

  @override
  Widget build(BuildContext context) {
    // Obtener ingredientes disponibles para sugerir recetas
    KitchenIngredient kitchenHelper = KitchenIngredient(name: '', quantity: '', location: '');
    List<KitchenIngredient> availableIngredients = kitchenHelper.getAvailableIngredientsOnly();

    List<Recipe> allRecipes = _getRecipes();
    List<Recipe> filteredRecipes = _getFilteredRecipes(allRecipes, availableIngredients);

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        title: const Text(
          'Recetas Recomendadas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 9, 77, 133),
        iconTheme: const IconThemeData(color: Colors.white),
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
                      selectedColor: const Color.fromARGB(255, 119, 161, 158),
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color: selectedFilter == filter ? Colors.white : Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Estadísticas rápidas
          _buildQuickStats(availableIngredients, filteredRecipes),
          
          // Lista de recetas
          Expanded(
            child: filteredRecipes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay recetas disponibles',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Prueba con otro filtro',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      return _buildRecipeCard(filteredRecipes[index], availableIngredients);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Recipe> _getRecipes() {
    return [
      Recipe(
        name: 'Tortilla de Huevos',
        description: 'Una deliciosa tortilla con los ingredientes que tienes disponibles',
        prepTime: 15,
        difficulty: 'Fácil',
        ingredients: ['HUEVOS', 'SAL', 'ACEITE DE OLIVA'],
        instructions: [
          'Batir los huevos en un bowl',
          'Agregar sal al gusto',
          'Calentar aceite en una sartén',
          'Verter los huevos y cocinar por ambos lados'
        ],
        category: 'Desayuno',
        isFavorite: true,
      ),
      Recipe(
        name: 'Pasta Simple',
        description: 'Pasta con aceite de oliva y ajo',
        prepTime: 20,
        difficulty: 'Fácil',
        ingredients: ['PASTA', 'AJO', 'ACEITE DE OLIVA', 'SAL'],
        instructions: [
          'Hervir agua con sal',
          'Cocinar la pasta según las instrucciones',
          'Sofreír ajo en aceite de oliva',
          'Mezclar pasta con el sofrito'
        ],
        category: 'Almuerzo',
        isFavorite: false,
      ),
      Recipe(
        name: 'Arroz con Pollo',
        description: 'Clásico arroz con tuto de pollo',
        prepTime: 45,
        difficulty: 'Medio',
        ingredients: ['ARROZ', 'TUTO DE POLLO', 'CEBOLLA', 'AJO', 'ACEITE DE OLIVA', 'SAL'],
        instructions: [
          'Cortar el pollo en trozos',
          'Sofreír cebolla y ajo',
          'Agregar el pollo y dorar',
          'Añadir arroz y agua',
          'Cocinar a fuego lento por 25 minutos'
        ],
        category: 'Almuerzo',
        isFavorite: true,
      ),
      Recipe(
        name: 'Tostadas con Jamón y Queso',
        description: 'Desayuno rápido y delicioso',
        prepTime: 10,
        difficulty: 'Muy Fácil',
        ingredients: ['PAN', 'JAMÓN', 'QUESO', 'MANTEQUILLA'],
        instructions: [
          'Tostar las rebanadas de pan',
          'Untar mantequilla',
          'Agregar jamón y queso',
          'Servir inmediatamente'
        ],
        category: 'Desayuno',
        isFavorite: false,
      ),
      Recipe(
        name: 'Café con Leche',
        description: 'La bebida perfecta para empezar el día',
        prepTime: 5,
        difficulty: 'Muy Fácil',
        ingredients: ['CAFÉ', 'LECHE'],
        instructions: [
          'Preparar café concentrado',
          'Calentar la leche',
          'Mezclar café y leche',
          'Servir caliente'
        ],
        category: 'Bebida',
        isFavorite: true,
      ),
    ];
  }

  List<Recipe> _getFilteredRecipes(List<Recipe> recipes, List<KitchenIngredient> availableIngredients) {
    List<String> availableNames = availableIngredients.map((i) => i.name).toList();
    
    switch (selectedFilter) {
      case 'Con ingredientes disponibles':
        return recipes.where((recipe) {
          return recipe.ingredients.every((ingredient) => availableNames.contains(ingredient));
        }).toList();
      case 'Fáciles':
        return recipes.where((recipe) => recipe.difficulty == 'Fácil' || recipe.difficulty == 'Muy Fácil').toList();
      case 'Rápidas':
        return recipes.where((recipe) => recipe.prepTime <= 20).toList();
      case 'Favoritas':
        return recipes.where((recipe) => recipe.isFavorite).toList();
      default:
        return recipes;
    }
  }

  Widget _buildQuickStats(List<KitchenIngredient> availableIngredients, List<Recipe> filteredRecipes) {
    int canMake = filteredRecipes.where((recipe) {
      List<String> availableNames = availableIngredients.map((i) => i.name).toList();
      return recipe.ingredients.every((ingredient) => availableNames.contains(ingredient));
    }).length;
    
    int favorites = filteredRecipes.where((recipe) => recipe.isFavorite).length;
    int quick = filteredRecipes.where((recipe) => recipe.prepTime <= 20).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('Puedes hacer', canMake, const Color.fromARGB(255, 9, 77, 133))),
          const SizedBox(width: 8),
          Expanded(child: _buildStatCard('Favoritas', favorites, const Color.fromARGB(255, 119, 161, 158))),
          const SizedBox(width: 8),
          Expanded(child: _buildStatCard('Rápidas', quick, Colors.orange)),
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

  Widget _buildRecipeCard(Recipe recipe, List<KitchenIngredient> availableIngredients) {
    List<String> availableNames = availableIngredients.map((i) => i.name).toList();
    bool canMake = recipe.ingredients.every((ingredient) => availableNames.contains(ingredient));
    int availableCount = recipe.ingredients.where((ingredient) => availableNames.contains(ingredient)).length;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la receta
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: canMake ? const Color.fromARGB(255, 9, 77, 133) : Colors.grey[400],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        recipe.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (recipe.isFavorite)
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
              ],
            ),
          ),
          
          // Información de la receta
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildInfoChip(Icons.access_time, '${recipe.prepTime} min', Colors.blue),
                    const SizedBox(width: 8),
                    _buildInfoChip(_getDifficultyIcon(recipe.difficulty), recipe.difficulty, _getDifficultyColor(recipe.difficulty)),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.category, recipe.category, const Color.fromARGB(255, 119, 161, 158)),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Disponibilidad de ingredientes
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: canMake ? Colors.green[50] : Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: canMake ? Colors.green : Colors.orange,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        canMake ? Icons.check_circle : Icons.warning,
                        color: canMake ? Colors.green : Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          canMake 
                            ? '¡Puedes hacer esta receta!' 
                            : 'Tienes $availableCount de ${recipe.ingredients.length} ingredientes',
                          style: TextStyle(
                            color: canMake ? Colors.green[800] : Colors.orange[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showRecipeDetails(recipe),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('Ver Receta'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 9, 77, 133),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _toggleFavorite(recipe),
                      icon: Icon(
                        recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: recipe.isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty) {
      case 'Muy Fácil':
        return Icons.star;
      case 'Fácil':
        return Icons.star_half;
      case 'Medio':
        return Icons.star_outline;
      default:
        return Icons.star_border;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Muy Fácil':
        return Colors.green;
      case 'Fácil':
        return Colors.lightGreen;
      case 'Medio':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  void _showRecipeDetails(Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(recipe.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ingredientes:',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...recipe.ingredients.map((ingredient) => Text('• $ingredient')),
              const SizedBox(height: 16),
              Text(
                'Instrucciones:',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...recipe.instructions.asMap().entries.map((entry) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('${entry.key + 1}. ${entry.value}'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(Recipe recipe) {
    setState(() {
      recipe.isFavorite = !recipe.isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          recipe.isFavorite 
            ? '${recipe.name} agregada a favoritas' 
            : '${recipe.name} removida de favoritas'
        ),
        backgroundColor: recipe.isFavorite ? Colors.green : Colors.orange,
      ),
    );
  }
}

class Recipe {
  final String name;
  final String description;
  final int prepTime;
  final String difficulty;
  final List<String> ingredients;
  final List<String> instructions;
  final String category;
  bool isFavorite;

  Recipe({
    required this.name,
    required this.description,
    required this.prepTime,
    required this.difficulty,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.isFavorite,
  });
}