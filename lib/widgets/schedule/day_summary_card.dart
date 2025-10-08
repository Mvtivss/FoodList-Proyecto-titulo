import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/meal_plan.dart';
import 'meal_section.dart';

class DaySummaryCard extends StatelessWidget {
  final String day;
  final Map<String, MealPlan?> meals;
  final Function(String, String, String, String, List<String>) onSaveMeal;

  const DaySummaryCard({
    super.key,
    required this.day,
    required this.meals,
    required this.onSaveMeal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ExpansionTile(
        title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: meals.keys.map((mealType) {
          return MealSection(
            day: day,
            mealType: mealType,
            meal: meals[mealType],
            onSaveMeal: onSaveMeal,
          );
        }).toList(),
      ),
    );
  }
}
