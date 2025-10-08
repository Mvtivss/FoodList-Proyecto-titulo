import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/meal_plan.dart';

class PlannedMeal extends StatelessWidget {
  final MealPlan meal;

  const PlannedMeal({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${meal.name} a las ${meal.time}"),
        Text("Ingredientes: ${meal.ingredients.join(", ")}"),
      ],
    );
  }
}
