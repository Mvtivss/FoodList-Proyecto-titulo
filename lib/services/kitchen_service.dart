import 'package:flutter_application_1/domain/entities/kitchen_ingredient.dart';
import 'package:flutter_application_1/services/api_service.dart';

class KitchenService {
  final String userId;

  KitchenService({required this.userId});

  // ==================== MÉTODOS SIMPLES (legacy) ====================
  
  Future<List<KitchenIngredient>> getIngredients() async {
    try {
      final items = await ApiService.fetchPantryItems(userId);
      return items.map((name) => KitchenIngredient(
        name: name,
        quantity: '1',
        location: 'Despensa',
      )).toList();
    } catch (e) {
      print('Error getIngredients: $e');
      return [];
    }
  }

  Future<bool> addIngredient(String name) async {
    try {
      final currentItems = await ApiService.fetchPantryItems(userId);
      if (!currentItems.contains(name)) {
        currentItems.add(name);
        return await ApiService.savePantryItems(userId, currentItems);
      }
      return false;
    } catch (e) {
      print('Error addIngredient: $e');
      return false;
    }
  }

  // ==================== MÉTODOS DETALLADOS (usar estos) ====================
  
  /// Obtener ingredientes con detalles completos
  Future<List<KitchenIngredient>> getIngredientsDetailed() async {
    try {
      final items = await ApiService.fetchPantryItemsDetailed(userId);
      return items.map((json) => KitchenIngredient.fromJson(json)).toList();
    } catch (e) {
      print('Error getIngredientsDetailed: $e');
      return [];
    }
  }

  /// Agregar ingrediente con detalles completos
  Future<bool> addIngredientDetailed(KitchenIngredient ingredient) async {
    try {
      final currentItems = await ApiService.fetchPantryItemsDetailed(userId);
      
      // Verificar si ya existe
      final exists = currentItems.any((item) => 
        item['name']?.toString().toLowerCase() == ingredient.name.toLowerCase()
      );
      
      if (exists) {
        print('El ingrediente "${ingredient.name}" ya existe');
        return false;
      }
      
      currentItems.add(ingredient.toJson());
      return await ApiService.savePantryItemsDetailed(userId, currentItems);
    } catch (e) {
      print('Error addIngredientDetailed: $e');
      return false;
    }
  }

  /// Actualizar ingrediente existente
  Future<bool> updateIngredient(String oldName, KitchenIngredient newIngredient) async {
    try {
      final currentItems = await ApiService.fetchPantryItemsDetailed(userId);
      final index = currentItems.indexWhere((item) => 
        item['name']?.toString().toLowerCase() == oldName.toLowerCase()
      );
      
      if (index != -1) {
        currentItems[index] = newIngredient.toJson();
        return await ApiService.savePantryItemsDetailed(userId, currentItems);
      }
      
      print('Ingrediente "$oldName" no encontrado para actualizar');
      return false;
    } catch (e) {
      print('Error updateIngredient: $e');
      return false;
    }
  }

  /// Eliminar ingrediente (CORREGIDO - usar método detallado)
  Future<bool> removeIngredient(String name) async {
    try {
      // USAR fetchPantryItemsDetailed en lugar de fetchPantryItems
      final currentItems = await ApiService.fetchPantryItemsDetailed(userId);
      
      // Filtrar el item a eliminar
      final filteredItems = currentItems.where((item) => 
        item['name']?.toString().toLowerCase() != name.toLowerCase()
      ).toList();
      
      // Si no se eliminó nada, retornar false
      if (filteredItems.length == currentItems.length) {
        print('Ingrediente "$name" no encontrado para eliminar');
        return false;
      }
      
      // USAR savePantryItemsDetailed en lugar de savePantryItems
      return await ApiService.savePantryItemsDetailed(userId, filteredItems);
    } catch (e) {
      print('Error removeIngredient: $e');
      return false;
    }
  }

  /// Eliminar múltiples ingredientes
  Future<bool> removeMultipleIngredients(List<String> names) async {
    try {
      final currentItems = await ApiService.fetchPantryItemsDetailed(userId);
      final namesToRemove = names.map((n) => n.toLowerCase()).toSet();
      
      final filteredItems = currentItems.where((item) => 
        !namesToRemove.contains(item['name']?.toString().toLowerCase())
      ).toList();
      
      return await ApiService.savePantryItemsDetailed(userId, filteredItems);
    } catch (e) {
      print('Error removeMultipleIngredients: $e');
      return false;
    }
  }

  /// Marcar ingrediente como agotado (sin eliminarlo)
  Future<bool> markAsUnavailable(String name) async {
    try {
      final currentItems = await ApiService.fetchPantryItemsDetailed(userId);
      final index = currentItems.indexWhere((item) => 
        item['name']?.toString().toLowerCase() == name.toLowerCase()
      );
      
      if (index != -1) {
        currentItems[index]['is_available'] = false;
        return await ApiService.savePantryItemsDetailed(userId, currentItems);
      }
      
      return false;
    } catch (e) {
      print('Error markAsUnavailable: $e');
      return false;
    }
  }

  /// Reactivar ingrediente agotado
  Future<bool> markAsAvailable(String name) async {
    try {
      final currentItems = await ApiService.fetchPantryItemsDetailed(userId);
      final index = currentItems.indexWhere((item) => 
        item['name']?.toString().toLowerCase() == name.toLowerCase()
      );
      
      if (index != -1) {
        currentItems[index]['is_available'] = true;
        return await ApiService.savePantryItemsDetailed(userId, currentItems);
      }
      
      return false;
    } catch (e) {
      print('Error markAsAvailable: $e');
      return false;
    }
  }
}