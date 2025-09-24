// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedDay = DateTime.now().weekday - 1; // 0 = Lunes

  final List<String> days = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
  ];

  final List<String> mealTypes = ['Desayuno', 'Almuerzo', 'Cena', 'Snack'];

  Map<String, Map<String, MealPlan?>> weeklySchedule = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.index = selectedDay;
    _initializeSchedule();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeSchedule() {
    for (String day in days) {
      weeklySchedule[day] = {};
      for (String mealType in mealTypes) {
        weeklySchedule[day]![mealType] = null;
      }
    }

    // Agregar algunos ejemplos
    weeklySchedule['Lunes']!['Desayuno'] = MealPlan(
      name: 'Tostadas con Jamón y Queso',
      time: '08:00',
      ingredients: ['Pan', 'Jamón', 'Queso', 'Mantequilla'],
      isCompleted: false,
    );
    weeklySchedule['Lunes']!['Almuerzo'] = MealPlan(
      name: 'Arroz con Pollo',
      time: '13:00',
      ingredients: ['Arroz', 'Tuto de Pollo', 'Cebolla', 'Ajo'],
      isCompleted: true,
    );
    weeklySchedule['Martes']!['Desayuno'] = MealPlan(
      name: 'Café con Leche',
      time: '08:30',
      ingredients: ['Café', 'Leche'],
      isCompleted: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        title: const Text(
          'FOODLIST - Horario de Comidas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 9, 77, 133),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: days.map((day) => Tab(text: day)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: days.map((day) => _buildDaySchedule(day)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMealPlan,
        backgroundColor: const Color.fromARGB(255, 9, 77, 133),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDaySchedule(String day) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resumen del día
          _buildDaySummary(day),
          const SizedBox(height: 20),
          
          // Planificación por tipo de comida
          ...mealTypes.map((mealType) => _buildMealSection(day, mealType)),
        ],
      ),
    );
  }

  Widget _buildDaySummary(String day) {
    Map<String, MealPlan?> dayPlan = weeklySchedule[day]!;
    int totalMeals = dayPlan.values.where((meal) => meal != null).length;
    int completedMeals = dayPlan.values.where((meal) => meal != null && meal.isCompleted).length;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color.fromARGB(255, 9, 77, 133), Color.fromARGB(255, 119, 161, 158)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Planificación para $day',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$totalMeals comidas planificadas',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    '$completedMeals completadas',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$totalMeals',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSection(String day, String mealType) {
    MealPlan? meal = weeklySchedule[day]![mealType];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del tipo de comida
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getMealTypeColor(mealType).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getMealTypeIcon(mealType),
                  color: _getMealTypeColor(mealType),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  mealType,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getMealTypeColor(mealType),
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                if (meal != null)
                  Text(
                    meal.time,
                    style: TextStyle(
                      color: _getMealTypeColor(mealType),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          
          // Contenido de la comida
          Padding(
            padding: const EdgeInsets.all(12),
            child: meal == null 
              ? _buildEmptyMeal(day, mealType)
              : _buildPlannedMeal(day, mealType, meal),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMeal(String day, String mealType) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
          ),
          child: Column(
            children: [
              Icon(
                Icons.add_circle_outline,
                color: Colors.grey[400],
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                'No hay comida planificada',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () => _addMealForSlot(day, mealType),
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Agregar Comida'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _getMealTypeColor(mealType),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildPlannedMeal(String day, String mealType, MealPlan meal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${meal.ingredients.length} ingredientes',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: meal.isCompleted,
                  onChanged: (value) => _toggleMealCompletion(day, mealType),
                  activeColor: Colors.green,
                ),
                Text(
                  meal.isCompleted ? 'Completado' : 'Pendiente',
                  style: TextStyle(
                    color: meal.isCompleted ? Colors.green : Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Ingredientes
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: meal.ingredients.map((ingredient) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getMealTypeColor(mealType).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              ingredient,
              style: TextStyle(
                fontSize: 10,
                color: _getMealTypeColor(mealType),
              ),
            ),
          )).toList(),
        ),
        
        const SizedBox(height: 12),
        
        // Botones de acción
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _editMeal(day, mealType, meal),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Editar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _getMealTypeColor(mealType),
                  side: BorderSide(color: _getMealTypeColor(mealType)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _startCooking(meal),
                icon: const Icon(Icons.restaurant, size: 16),
                label: const Text('Cocinar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getMealTypeColor(mealType),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getMealTypeColor(String mealType) {
    switch (mealType) {
      case 'Desayuno':
        return Colors.orange;
      case 'Almuerzo':
        return const Color.fromARGB(255, 9, 77, 133);
      case 'Cena':
        return const Color.fromARGB(255, 119, 161, 158);
      case 'Snack':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getMealTypeIcon(String mealType) {
    switch (mealType) {
      case 'Desayuno':
        return Icons.wb_sunny;
      case 'Almuerzo':
        return Icons.lunch_dining;
      case 'Cena':
        return Icons.dinner_dining;
      case 'Snack':
        return Icons.fastfood;
      default:
        return Icons.restaurant;
    }
  }

  void _addMealPlan() {
    String currentDay = days[_tabController.index];
    _showMealPlanDialog(currentDay, null, null);
  }

  void _addMealForSlot(String day, String mealType) {
    _showMealPlanDialog(day, mealType, null);
  }

  void _editMeal(String day, String mealType, MealPlan meal) {
    _showMealPlanDialog(day, mealType, meal);
  }

  void _showMealPlanDialog(String day, String? mealType, MealPlan? existingMeal) {
    final nameController = TextEditingController(text: existingMeal?.name ?? '');
    final timeController = TextEditingController(text: existingMeal?.time ?? '');
    String selectedMealType = mealType ?? mealTypes.first;
    List<String> ingredients = List.from(existingMeal?.ingredients ?? []);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(existingMeal == null ? 'Agregar Comida' : 'Editar Comida'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la comida',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                
                DropdownButtonFormField<String>(
                  value: selectedMealType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de comida',
                    border: OutlineInputBorder(),
                  ),
                  items: mealTypes.map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  )).toList(),
                  onChanged: mealType == null ? (value) {
                    setDialogState(() {
                      selectedMealType = value!;
                    });
                  } : null,
                ),
                const SizedBox(height: 12),
                
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'Hora (HH:MM)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Lista de ingredientes
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Ingredientes:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          IconButton(
                            onPressed: () => _showAddIngredientDialog(setDialogState, ingredients),
                            icon: const Icon(Icons.add, size: 20),
                          ),
                        ],
                      ),
                      if (ingredients.isEmpty)
                        const Text('No hay ingredientes agregados', style: TextStyle(color: Colors.grey))
                      else
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: ingredients.map((ingredient) => Chip(
                            label: Text(ingredient, style: const TextStyle(fontSize: 10)),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setDialogState(() {
                                ingredients.remove(ingredient);
                              });
                            },
                          )).toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            if (existingMeal != null)
              TextButton(
                onPressed: () {
                  _deleteMeal(day, selectedMealType);
                  Navigator.pop(context);
                },
                child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && timeController.text.isNotEmpty) {
                  _saveMeal(day, selectedMealType, nameController.text, timeController.text, ingredients);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 9, 77, 133),
                foregroundColor: Colors.white,
              ),
              child: Text(existingMeal == null ? 'Agregar' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddIngredientDialog(StateSetter setDialogState, List<String> ingredients) {
    final ingredientController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Ingrediente'),
        content: TextField(
          controller: ingredientController,
          decoration: const InputDecoration(
            labelText: 'Nombre del ingrediente',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (ingredientController.text.isNotEmpty) {
                setDialogState(() {
                  ingredients.add(ingredientController.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _saveMeal(String day, String mealType, String name, String time, List<String> ingredients) {
    setState(() {
      weeklySchedule[day]![mealType] = MealPlan(
        name: name,
        time: time,
        ingredients: ingredients,
        isCompleted: false,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comida guardada para $day'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteMeal(String day, String mealType) {
    setState(() {
      weeklySchedule[day]![mealType] = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comida eliminada de $day'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _toggleMealCompletion(String day, String mealType) {
    setState(() {
      MealPlan? meal = weeklySchedule[day]![mealType];
      if (meal != null) {
        meal.isCompleted = !meal.isCompleted;
      }
    });
  }

  void _startCooking(MealPlan meal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.restaurant, color: Colors.orange),
            const SizedBox(width: 8),
            Text('Cocinar ${meal.name}'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingredientes necesarios:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...meal.ingredients.map((ingredient) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(ingredient),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '¡Es hora de cocinar! Asegúrate de tener todos los ingredientes listos.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('¡Disfruta cocinando ${meal.name}!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('¡Empezar a cocinar!'),
          ),
        ],
      ),
    );
  }
}

class MealPlan {
  String name;
  String time;
  List<String> ingredients;
  bool isCompleted;

  MealPlan({
    required this.name,
    required this.time,
    required this.ingredients,
    required this.isCompleted,
  });
}