import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../models/meal_plan.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedDay = DateTime.now().weekday - 1; // 0 = lunes

  final List<String> days = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];

  final List<String> mealTypes = ['Desayuno', 'Almuerzo', 'Cena', 'Snack'];

  Map<String, Map<String, MealPlan?>> weeklySchedule = {};

  String? userId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.index = selectedDay;
    _initializeSchedule();
    _loadUserAndSchedule();
    NotificationService().initialize();
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
  }

  Future<void> _loadUserAndSchedule() async {
    final userData = await ApiService.getUserData();
    if (userData == null) return;

    userId = userData['id'];
    if (userId != null) {
      await _fetchWeeklySchedule();
    }
  }

  Future<void> _fetchWeeklySchedule() async {
    if (userId == null) return;
    try {
      final data = await ApiService.fetchWeeklySchedule(userId!);
      setState(() {
        for (String day in days) {
          weeklySchedule[day] = {};
          final dayIndex = days.indexOf(day);
          final dayData = (data is List && dayIndex >= 0 && dayIndex < data.length)
              ? data[dayIndex] ?? {}
              : (data is Map<String, dynamic> && (data as Map<String, dynamic>).containsKey(day) ? (data as Map<String, dynamic>)[day] ?? {} : {});
          final Map<String, dynamic> dayDataMap = dayData is Map<String, dynamic>
              ? dayData
              : <String, dynamic>{};
          for (String mealType in mealTypes) {
            if (dayDataMap[mealType] != null) {
              weeklySchedule[day]![mealType] =
                  MealPlan.fromJson(dayDataMap[mealType]);
            } else {
              weeklySchedule[day]![mealType] = null;
            }
          }
        }
      });
    } catch (e) {
      print("Error cargando schedule: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FOODLIST - Horario de Comidas'),
        backgroundColor: const Color.fromARGB(255, 9, 77, 133),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
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
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDaySchedule(String day) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDaySummary(day),
          const SizedBox(height: 16),
          ...mealTypes.map((mealType) => _buildMealSection(day, mealType)),
        ],
      ),
    );
  }

  Widget _buildDaySummary(String day) {
    final dayPlan = weeklySchedule[day]!;
    final totalMeals = dayPlan.values.where((m) => m != null).length;
    final completedMeals =
        dayPlan.values.where((m) => m != null && m!.isCompleted).length;

    return Card(
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
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text('$totalMeals comidas planificadas', style: const TextStyle(color: Colors.white70)),
                  Text('$completedMeals completadas', style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.white24,
              child: Text(
                '$totalMeals',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMealSection(String day, String mealType) {
    final meal = weeklySchedule[day]![mealType];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: _getMealTypeColor(mealType).withOpacity(0.1),
            child: Row(
              children: [
                Icon(_getMealTypeIcon(mealType), color: _getMealTypeColor(mealType)),
                const SizedBox(width: 8),
                Text(mealType, style: TextStyle(color: _getMealTypeColor(mealType), fontWeight: FontWeight.bold)),
                const Spacer(),
                if (meal != null) Text(meal.time, style: TextStyle(color: _getMealTypeColor(mealType))),
              ],
            ),
          ),
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(Icons.add_circle_outline, size: 40, color: Colors.grey[400]),
              const SizedBox(height: 8),
              const Text('No hay comida planificada', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () => _addMealForSlot(day, mealType),
          icon: const Icon(Icons.add),
          label: const Text('Agregar Comida'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _getMealTypeColor(mealType),
            foregroundColor: Colors.white,
          ),
        )
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
                  Text(meal.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('${meal.ingredients.length} ingredientes', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Checkbox(
              value: meal.isCompleted,
              onChanged: (val) => _toggleMealCompletion(day, mealType),
              activeColor: Colors.green,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: meal.ingredients
              .map((ing) => Chip(label: Text(ing, style: const TextStyle(fontSize: 10))))
              .toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _editMeal(day, mealType, meal),
                icon: const Icon(Icons.edit),
                label: const Text('Editar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _getMealTypeColor(mealType),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _startCooking(meal),
                icon: const Icon(Icons.restaurant),
                label: const Text('Cocinar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getMealTypeColor(mealType),
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
    final day = days[_tabController.index];
    _showMealDialog(day, null, null);
  }

  void _addMealForSlot(String day, String mealType) {
    _showMealDialog(day, mealType, null);
  }

  void _editMeal(String day, String mealType, MealPlan meal) {
    _showMealDialog(day, mealType, meal);
  }

  Future<void> _showMealDialog(String day, String? mealType, MealPlan? existingMeal) async {
    final nameController = TextEditingController(text: existingMeal?.name ?? '');
    final timeController = TextEditingController(text: existingMeal?.time ?? '');
    String selectedMealType = mealType ?? mealTypes.first;
    List<String> ingredients = List.from(existingMeal?.ingredients ?? []);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(existingMeal == null ? 'Agregar Comida' : 'Editar Comida'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nombre de la comida'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedMealType,
                    decoration: const InputDecoration(labelText: 'Tipo de comida'),
                    items: mealTypes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setStateDialog(() => selectedMealType = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: timeController,
                    decoration: const InputDecoration(labelText: 'Hora (HH:mm)'),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: ingredients
                        .map((ing) => Chip(
                              label: Text(ing),
                              onDeleted: () => setStateDialog(() => ingredients.remove(ing)),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 4),
                  OutlinedButton(
                    onPressed: () async {
                      final ingredient = await _showAddIngredientDialog();
                      if (ingredient != null && ingredient.isNotEmpty) {
                        setStateDialog(() => ingredients.add(ingredient));
                      }
                    },
                    child: const Text('Agregar Ingrediente'),
                  ),
                ],
              ),
            ),
            actions: [
              if (existingMeal != null)
                TextButton(
                  onPressed: () => _deleteMeal(day, selectedMealType, existingMeal.id),
                  child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                ),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: () => _saveMeal(day, selectedMealType, nameController.text, timeController.text, ingredients, existingMeal?.id),
                child: Text(existingMeal == null ? 'Agregar' : 'Guardar'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<String?> _showAddIngredientDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo ingrediente'),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Agregar')),
        ],
      ),
    );
  }

  Future<void> _saveMeal(String day, String mealType, String name, String time, List<String> ingredients, String? mealId) async {
    if (userId == null) return;
    final mealPlan = MealPlan(
      id: mealId ?? '',
      day: day,
      mealType: mealType,
      name: name,
      time: time,
      ingredients: ingredients,
      isCompleted: false,
      notificationEnabled: true,
    );

    setState(() {
      weeklySchedule[day]![mealType] = mealPlan;
    });

    try {
      await ApiService.saveMealPlan(userId!, mealPlan);
      if (mealPlan.notificationEnabled) {
        final id = NotificationService.generateNotificationId(day, mealType);
        await NotificationService().scheduleMealNotification(
          id: id,
          mealType: mealType,
          mealName: name,
          day: day,
          time: time,
        );
      }
      Navigator.pop(context);
    } catch (e) {
      print('Error guardando mealPlan: $e');
    }
  }

  Future<void> _deleteMeal(String day, String mealType, String mealId) async {
    if (userId == null) return;
    setState(() {
      weeklySchedule[day]![mealType] = null;
    });
    try {
      await ApiService.deleteMealPlan(userId!, day);
      final notificationId = NotificationService.generateNotificationId(day, mealType);
      await NotificationService().cancelNotification(notificationId);
      Navigator.pop(context);
    } catch (e) {
      print('Error eliminando mealPlan: $e');
    }
  }

  void _toggleMealCompletion(String day, String mealType) {
    final meal = weeklySchedule[day]![mealType];
    if (meal == null) return;
    setState(() {
      meal.isCompleted = !meal.isCompleted;
    });
    _saveMeal(day, mealType, meal.name, meal.time, meal.ingredients, meal.id);
  }

  void _startCooking(MealPlan meal) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('¡Hora de cocinar ${meal.name}!')));
  }
}
