class KitchenIngredient {
  final String name;
  final String quantity;
  final String location;
  final DateTime? expirationDate;
  final bool isAvailable;

  KitchenIngredient({
    required this.name,
    this.quantity = '1',
    this.location = 'Despensa',
    this.expirationDate,
    this.isAvailable = true,
  });

  // Métodos de utilidad
  bool isExpired() {
    if (expirationDate == null) return false;
    return DateTime.now().isAfter(expirationDate!);
  }

  bool isExpiringSoon(int days) {
    if (expirationDate == null) return false;
    final difference = expirationDate!.difference(DateTime.now()).inDays;
    return difference >= 0 && difference <= days;
  }

  // Conversión desde JSON (si decides expandir el backend)
  factory KitchenIngredient.fromJson(Map<String, dynamic> json) {
    return KitchenIngredient(
      name: json['name'] ?? '',
      quantity: json['quantity']?.toString() ?? '1',
      location: json['location'] ?? 'Despensa',
      expirationDate: json['expiration_date'] != null 
          ? DateTime.parse(json['expiration_date']) 
          : null,
      isAvailable: json['is_available'] ?? true,
    );
  }

  // Conversión a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'location': location,
      'expiration_date': expirationDate?.toIso8601String(),
      'is_available': isAvailable,
    };
  }
}