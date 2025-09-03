// kitchen_ingredient.dart

class KitchenIngredient {
  final String name;
  final String quantity;
  final DateTime? expirationDate;
  final String location;
  final bool isAvailable;

  KitchenIngredient({
    required this.name,
    required this.quantity,
    this.expirationDate,
    required this.location,
    this.isAvailable = true,
  });

  List<KitchenIngredient> getAvailableIngredients() {
    final today = DateTime.now();
    
    return [
      // Proteínas en el refrigerador
      KitchenIngredient(
        name: 'TUTO DE POLLO', 
        quantity: '300gr', 
        expirationDate: today.add(Duration(days: 3)),
        location: 'Refrigerador',
        isAvailable: true,
      ),
      KitchenIngredient(
        name: 'HUEVOS', 
        quantity: '8 unidades', 
        expirationDate: today.add(Duration(days: 15)),
        location: 'Refrigerador',
        isAvailable: true,
      ),
      KitchenIngredient(
        name: 'QUESO', 
        quantity: '250gr', 
        expirationDate: today.add(Duration(days: 7)),
        location: 'Refrigerador',
        isAvailable: true,
      ),
      KitchenIngredient(
        name: 'JAMÓN', 
        quantity: '250gr', 
        expirationDate: today.add(Duration(days: 5)),
        location: 'Refrigerador',
        isAvailable: true,
      ),

      // Lácteos en el refrigerador
      KitchenIngredient(
        name: 'LECHE', 
        quantity: '500ml', 
        expirationDate: today.add(Duration(days: 4)),
        location: 'Refrigerador',
        isAvailable: true,
      ),
      KitchenIngredient(
        name: 'YOGUR', 
        quantity: '350ml', 
        expirationDate: today.add(Duration(days: 8)),
        location: 'Refrigerador',
        isAvailable: true,
      ),
      KitchenIngredient(
        name: 'MANTEQUILLA', 
        quantity: '200gr', 
        expirationDate: today.add(Duration(days: 30)),
        location: 'Refrigerador',
        isAvailable: true,
      ),

      // Cereales y granos en la despensa
      KitchenIngredient(
        name: 'ARROZ', 
        quantity: '800gr', 
        expirationDate: today.add(Duration(days: 365)),
        location: 'Despensa',
        isAvailable: true,
      ),
      KitchenIngredient(
        name: 'PASTA', 
        quantity: '400gr', 
        expirationDate: today.add(Duration(days: 200)),
        location: 'Despensa',
        isAvailable: true,
      ),

      // Pan en la panera
      KitchenIngredient(
        name: 'PAN', 
        quantity: '250gr', 
        expirationDate: today.add(Duration(days: 2)),
        location: 'Panera',
        isAvailable: true,
      ),

      // Aceites y condimentos en la despensa
      KitchenIngredient(
        name: 'ACEITE DE OLIVA', 
        quantity: '300ml', 
        expirationDate: today.add(Duration(days: 180)),
        location: 'Despensa',
        isAvailable: true,
      ),
      KitchenIngredient(
        name: 'SAL', 
        quantity: '500gr', 
        expirationDate: null, // La sal no vence
        location: 'Despensa',
        isAvailable: true,
      ),
      KitchenIngredient(
        name: 'PIMIENTA', 
        quantity: '50gr', 
        expirationDate: today.add(Duration(days: 365)),
        location: 'Despensa',
        isAvailable: true,
      ),

      // Verduras frescas en el refrigerador
      KitchenIngredient(
        name: 'CEBOLLA', 
        quantity: '2 unidades', 
        expirationDate: today.add(Duration(days: 10)),
        location: 'Refrigerador',
        isAvailable: true,
      ),
      KitchenIngredient(
        name: 'AJO', 
        quantity: '1 cabeza', 
        expirationDate: today.add(Duration(days: 14)),
        location: 'Despensa',
        isAvailable: true,
      ),
      KitchenIngredient(
        name: 'TOMATE', 
        quantity: '3 unidades', 
        expirationDate: today.add(Duration(days: 5)),
        location: 'Refrigerador',
        isAvailable: true,
      ),

      // Bebidas en la despensa
      KitchenIngredient(
        name: 'CAFÉ', 
        quantity: '150gr', 
        expirationDate: today.add(Duration(days: 120)),
        location: 'Despensa',
        isAvailable: true,
      ),

      // Algunos ingredientes agotados
      KitchenIngredient(
        name: 'AZÚCAR', 
        quantity: '0gr', 
        expirationDate: today.add(Duration(days: 300)),
        location: 'Despensa',
        isAvailable: false, // Se acabó
      ),
      KitchenIngredient(
        name: 'LECHUGA', 
        quantity: '1 unidad', 
        expirationDate: today.subtract(Duration(days: 1)), // Vencida
        location: 'Refrigerador',
        isAvailable: false,
      ),
    ];
  }

  // Métodos útiles para manejo de ingredientes
  bool isExpired() {
    if (expirationDate == null) return false;
    return DateTime.now().isAfter(expirationDate!);
  }

  bool isExpiringSoon(int daysThreshold) {
    if (expirationDate == null) return false;
    final threshold = DateTime.now().add(Duration(days: daysThreshold));
    return expirationDate!.isBefore(threshold) && !isExpired();
  }

  List<KitchenIngredient> getExpiredIngredients() {
    return getAvailableIngredients().where((ingredient) => ingredient.isExpired()).toList();
  }

  List<KitchenIngredient> getExpiringSoonIngredients({int days = 3}) {
    return getAvailableIngredients().where((ingredient) => ingredient.isExpiringSoon(days)).toList();
  }

  List<KitchenIngredient> getAvailableIngredientsOnly() {
    return getAvailableIngredients().where((ingredient) => ingredient.isAvailable && !ingredient.isExpired()).toList();
  }

  List<KitchenIngredient> getIngredientsByLocation(String location) {
    return getAvailableIngredients().where((ingredient) => ingredient.location == location).toList();
  }
}