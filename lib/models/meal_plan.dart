class MealPlan {
  String id;
  String day;
  String mealType;
  String name;
  String time; // formato HH:mm
  List<String> ingredients;
  bool isCompleted;
  bool notificationEnabled;

  MealPlan({
    required this.id,
    required this.day,
    required this.mealType,
    required this.name,
    required this.time,
    required this.ingredients,
    this.isCompleted = false,
    this.notificationEnabled = true,
  });

  // Factory para parsear desde JSON (del backend)
  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['_id'] ?? '',
      day: json['day'],
      mealType: json['meal_type'],
      name: json['name'],
      time: json['time'],
      ingredients: List<String>.from(json['ingredients']),
      isCompleted: json['is_completed'] ?? false,
      notificationEnabled: json['notification_enabled'] ?? true,
    );
  }

  // Convertir a JSON para enviar al backend
  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "meal_type": mealType,
      "name": name,
      "time": time,
      "ingredients": ingredients,
      "is_completed": isCompleted,
      "notification_enabled": notificationEnabled,
    };
  }
}
