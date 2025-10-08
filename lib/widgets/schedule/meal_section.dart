import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/meal_plan.dart';
import 'planned_meal.dart';

class MealSection extends StatelessWidget {
  final String day;
  final String mealType;
  final MealPlan? meal;
  final Function(String, String, String, String, List<String>) onSaveMeal;

  const MealSection({
    super.key,
    required this.day,
    required this.mealType,
    required this.meal,
    required this.onSaveMeal,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(mealType),
      subtitle: meal == null
          ? TextButton(
              onPressed: () {
                onSaveMeal(day, mealType, "Ensalada", "14:00", ["Lechuga", "Tomate"]);
              },
              child: const Text("Agregar comida"),
            )
          : PlannedMeal(meal: meal!),
    );
  }
}
