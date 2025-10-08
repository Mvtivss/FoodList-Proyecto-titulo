import 'package:flutter_application_1/domain/entities/kitchen_ingredient.dart';
import 'package:flutter_application_1/services/kitchen_service.dart';
import 'package:flutter_application_1/services/api_service.dart';

class RecipeSuggestionsService {
  final String userId;
  late KitchenService _kitchenService;

  RecipeSuggestionsService({required this.userId}) {
    _kitchenService = KitchenService(userId: userId);
  }

  /// Obtener ingredientes disponibles desde el backend
  Future<List<KitchenIngredient>> getAvailableIngredients() async {
    try {
      final allIngredients = await _kitchenService.getIngredients();
      // Filtrar solo los disponibles y no vencidos
      return allIngredients.where((ingredient) => 
        ingredient.isAvailable && !ingredient.isExpired()
      ).toList();
    } catch (e) {
      print('Error getAvailableIngredients: $e');
      return [];
    }
  }

  /// Obtener nombres de ingredientes disponibles
  Future<List<String>> getAvailableIngredientNames() async {
    try {
      final ingredients = await getAvailableIngredients();
      return ingredients.map((ing) => ing.name).toList();
    } catch (e) {
      print('Error getAvailableIngredientNames: $e');
      return [];
    }
  }

  /// Buscar recetas basadas en ingredientes disponibles
  Future<List<Map<String, dynamic>>> searchRecipesByIngredients() async {
    try {
      final ingredientNames = await getAvailableIngredientNames();
      
      if (ingredientNames.isEmpty) {
        return [];
      }

      // Aquí puedes integrar con una API de recetas real
      // Por ejemplo: Spoonacular, Edamam, TheMealDB, etc.
      
      // Ejemplo con una API ficticia:
      // final response = await http.get(
      //   Uri.parse('https://api.recetas.com/search?ingredients=${ingredientNames.join(',')}'),
      // );
      
      // Por ahora retornamos recetas de ejemplo basadas en los ingredientes
      return _generateMockRecipes(ingredientNames);
    } catch (e) {
      print('Error searchRecipesByIngredients: $e');
      return [];
    }
  }

  /// Obtener ingredientes que están por vencer (para priorizar)
  Future<List<KitchenIngredient>> getIngredientsByPriority() async {
    try {
      final allIngredients = await _kitchenService.getIngredients();
      
      // Separar por prioridad
      final expiringSoon = allIngredients.where((ing) => 
        ing.isExpiringSoon(3) && !ing.isExpired() && ing.isAvailable
      ).toList();
      
      final available = allIngredients.where((ing) => 
        ing.isAvailable && !ing.isExpired() && !ing.isExpiringSoon(3)
      ).toList();

      // Retornar primero los que están por vencer
      return [...expiringSoon, ...available];
    } catch (e) {
      print('Error getIngredientsByPriority: $e');
      return [];
    }
  }

  /// Calcular match de una receta con ingredientes disponibles
  Future<Map<String, dynamic>> calculateRecipeMatch(List<String> recipeIngredients) async {
    try {
      final availableNames = await getAvailableIngredientNames();
      final availableNamesLower = availableNames.map((n) => n.toLowerCase()).toList();
      
      int matchCount = 0;
      List<String> matchedIngredients = [];
      List<String> missingIngredients = [];

      for (var ingredient in recipeIngredients) {
        final ingredientLower = ingredient.toLowerCase();
        if (availableNamesLower.any((available) => 
            ingredientLower.contains(available) || available.contains(ingredientLower))) {
          matchCount++;
          matchedIngredients.add(ingredient);
        } else {
          missingIngredients.add(ingredient);
        }
      }

      double matchPercentage = recipeIngredients.isEmpty 
          ? 0 
          : (matchCount / recipeIngredients.length) * 100;

      return {
        'match_count': matchCount,
        'total_ingredients': recipeIngredients.length,
        'match_percentage': matchPercentage,
        'matched_ingredients': matchedIngredients,
        'missing_ingredients': missingIngredients,
      };
    } catch (e) {
      print('Error calculateRecipeMatch: $e');
      return {
        'match_count': 0,
        'total_ingredients': recipeIngredients.length,
        'match_percentage': 0.0,
        'matched_ingredients': [],
        'missing_ingredients': recipeIngredients,
      };
    }
  }

  /// Generar recetas de ejemplo (reemplazar con API real)
  List<Map<String, dynamic>> _generateMockRecipes(List<String> ingredients) {
    // Esta es una función de ejemplo. Deberías integrar una API real de recetas.
    List<Map<String, dynamic>> mockRecipes = [];

    // Categorizar ingredientes
    final hasRice = ingredients.any((i) => i.toLowerCase().contains('arroz'));
    final hasPasta = ingredients.any((i) => i.toLowerCase().contains('pasta') || i.toLowerCase().contains('fideos'));
    final hasChicken = ingredients.any((i) => i.toLowerCase().contains('pollo'));
    final hasTomato = ingredients.any((i) => i.toLowerCase().contains('tomate'));
    final hasOnion = ingredients.any((i) => i.toLowerCase().contains('cebolla'));
    final hasEgg = ingredients.any((i) => i.toLowerCase().contains('huevo'));

    if (hasRice && hasChicken) {
      mockRecipes.add({
        'id': '1',
        'name': 'Arroz con Pollo',
        'description': 'Plato tradicional delicioso y nutritivo',
        'ingredients': ['Arroz', 'Pollo', 'Cebolla', 'Ajo', 'Caldo'],
        'prep_time': 45,
        'difficulty': 'Fácil',
        'image_url': 'https://via.placeholder.com/300x200?text=Arroz+con+Pollo',
      });
    }

    if (hasPasta && hasTomato) {
      mockRecipes.add({
        'id': '2',
        'name': 'Pasta con Salsa de Tomate',
        'description': 'Pasta italiana clásica',
        'ingredients': ['Pasta', 'Tomate', 'Albahaca', 'Ajo', 'Aceite de oliva'],
        'prep_time': 25,
        'difficulty': 'Fácil',
        'image_url': 'https://via.placeholder.com/300x200?text=Pasta+Tomate',
      });
    }

    if (hasEgg && hasOnion) {
      mockRecipes.add({
        'id': '3',
        'name': 'Tortilla de Huevo',
        'description': 'Tortilla simple y deliciosa',
        'ingredients': ['Huevo', 'Cebolla', 'Sal', 'Pimienta'],
        'prep_time': 15,
        'difficulty': 'Muy Fácil',
        'image_url': 'https://via.placeholder.com/300x200?text=Tortilla',
      });
    }

    if (mockRecipes.isEmpty) {
      mockRecipes.add({
        'id': '4',
        'name': 'Ensalada Mixta',
        'description': 'Ensalada fresca con tus ingredientes disponibles',
        'ingredients': ingredients.take(5).toList(),
        'prep_time': 10,
        'difficulty': 'Muy Fácil',
        'image_url': 'https://via.placeholder.com/300x200?text=Ensalada',
      });
    }

    return mockRecipes;
  }

  /// Agregar ingredientes faltantes a la lista de compras
  Future<bool> addMissingIngredientsToShoppingList(List<String> missingIngredients) async {
    // Implementar cuando tengas un servicio de lista de compras
    try {
      // Ejemplo: await ShoppingListService(userId: userId).addItems(missingIngredients);
      return true;
    } catch (e) {
      print('Error addMissingIngredientsToShoppingList: $e');
      return false;
    }
  }

  /// Marcar ingredientes como usados después de cocinar una receta
  Future<bool> markIngredientsAsUsed(List<String> usedIngredients) async {
    try {
      for (var ingredientName in usedIngredients) {
        await _kitchenService.removeIngredient(ingredientName);
      }
      return true;
    } catch (e) {
      print('Error markIngredientsAsUsed: $e');
      return false;
    }
  }
}