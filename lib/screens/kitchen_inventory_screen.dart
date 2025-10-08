import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/kitchen_ingredient.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/services/kitchen_service.dart';
import 'package:flutter_application_1/services/notification_service.dart';
import 'package:flutter_application_1/widgets/kitchen_invetory/filter_chips_widget.dart';
import 'package:flutter_application_1/widgets/kitchen_invetory/quick_stats_widget.dart';
import 'package:flutter_application_1/widgets/kitchen_invetory/ingredient_group_widget.dart';
import 'package:flutter_application_1/widgets/add_ingredient_dialog.dart';
import 'package:flutter_application_1/widgets/edit_ingredient_dialog.dart';

class KitchenInventoryScreen extends StatefulWidget {
  const KitchenInventoryScreen({super.key});

  @override
  State<KitchenInventoryScreen> createState() => _KitchenInventoryScreenState();
}

class _KitchenInventoryScreenState extends State<KitchenInventoryScreen> {
  String selectedFilter = 'Todos';
  final List<String> filterOptions = [
    'Todos',
    'Disponibles',
    'Por vencer',
    'Vencidos',
    'Agotados'
  ];

  List<KitchenIngredient> allIngredients = [];
  bool isLoading = true;
  String? errorMessage;

  late KitchenService kitchenService;

  @override
  void initState() {
    super.initState();
    _initIngredients();
  }

  Future<void> _initIngredients() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final userData = await ApiService.getUserData();
      if (userData != null) {
        kitchenService = KitchenService(userId: userData['id']);
        
        // SIEMPRE usar getIngredientsDetailed
        List<KitchenIngredient> ingredients = await kitchenService.getIngredientsDetailed();
        
        if (mounted) {
          setState(() {
            allIngredients = ingredients;
            isLoading = false;
          });
          
          // AHORA SÍ verificar notificaciones (después de cargar correctamente)
          _checkNotifications(ingredients);
        }
      } else {
        if (mounted) {
          setState(() {
            allIngredients = [];
            isLoading = false;
            errorMessage = 'No se encontró información del usuario';
          });
        }
      }
    } catch (e) {
      debugPrint('Error _initIngredients: $e');
      if (mounted) {
        setState(() {
          allIngredients = [];
          isLoading = false;
          errorMessage = 'Error al cargar ingredientes: $e';
        });
      }
    }
  }

  // Verificar notificaciones en segundo plano
  Future<void> _checkNotifications(List<KitchenIngredient> ingredients) async {
    try {
      await NotificationService().checkExpiringIngredients(ingredients);
      debugPrint('✅ Notificaciones verificadas para ${ingredients.length} ingredientes');
    } catch (e) {
      debugPrint('⚠️ Error verificando notificaciones: $e');
    }
  }

  Future<void> _addIngredient(KitchenIngredient ingredient) async {
    setState(() {
      isLoading = true;
    });

    try {
      bool success = await kitchenService.addIngredientDetailed(ingredient);
      
      if (success) {
        await _initIngredients(); // Esto ya incluye la verificación de notificaciones
        if (mounted) {
          _showSnackBar('Ingrediente agregado correctamente');
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          _showSnackBar('Error al agregar el ingrediente', isError: true);
        }
      }
    } catch (e) {
      debugPrint('Error _addIngredient: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        _showSnackBar('Error: $e', isError: true);
      }
    }
  }

  Future<void> _editIngredient(String oldName, KitchenIngredient newIngredient) async {
    setState(() {
      isLoading = true;
    });

    try {
      bool success = await kitchenService.updateIngredient(oldName, newIngredient);
      
      if (success) {
        await _initIngredients();
        if (mounted) {
          _showSnackBar('Ingrediente actualizado correctamente');
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          _showSnackBar('Error al actualizar el ingrediente', isError: true);
        }
      }
    } catch (e) {
      debugPrint('Error _editIngredient: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        _showSnackBar('Error: $e', isError: true);
      }
    }
  }

  Future<void> _removeIngredient(String name) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange[700]),
            const SizedBox(width: 12),
            const Text('Confirmar eliminación'),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.grey[800], fontSize: 16),
            children: [
              const TextSpan(text: '¿Estás seguro de eliminar '),
              TextSpan(
                text: '"$name"',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      isLoading = true;
    });

    try {
      bool success = await kitchenService.removeIngredient(name);
      
      if (success) {
        await _initIngredients();
        if (mounted) {
          _showSnackBar('Ingrediente eliminado correctamente');
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          _showSnackBar('Error al eliminar el ingrediente', isError: true);
        }
      }
    } catch (e) {
      debugPrint('Error _removeIngredient: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        _showSnackBar('Error: $e', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red[700] : Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<KitchenIngredient> filteredIngredients = _getFilteredIngredients(allIngredients);
    Map<String, List<KitchenIngredient>> ingredientsByLocation =
        _groupIngredientsByLocation(filteredIngredients);

    return Scaffold(
      appBar: _buildAppBar(),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Cargando ingredientes...',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : errorMessage != null
              ? _buildErrorWidget()
              : Column(
                  children: [
                    FilterChipsWidget(
                      filterOptions: filterOptions,
                      selectedFilter: selectedFilter,
                      onFilterChanged: (filter) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                    ),
                    QuickStatsWidget(ingredients: allIngredients),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _initIngredients,
                        child: _buildIngredientsList(
                          filteredIngredients,
                          ingredientsByLocation,
                        ),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
        backgroundColor: const Color.fromARGB(255, 9, 77, 133),
        foregroundColor: Colors.white,
      ),
    );
  }

  AppBar _buildAppBar() {
    // Contar alimentos por vencer o vencidos
    final expiredCount = allIngredients.where((i) => i.isExpired()).length;
    final expiringCount = allIngredients.where((i) => 
      i.isExpiringSoon(3) && !i.isExpired()
    ).length;
    final hasAlerts = expiredCount > 0 || expiringCount > 0;

    return AppBar(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      title: const Text(
        'Inventario de Cocina',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 9, 77, 133),
      actions: [
        // Badge de alertas
        if (hasAlerts)
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_active, color: Colors.white),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${expiredCount + expiringCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // Aquí puedes abrir el diálogo de alertas
              _showSnackBar(
                '$expiringCount por vencer, $expiredCount vencidos',
                isError: true,
              );
            },
            tooltip: 'Ver alertas',
          ),
        
        // Menú de opciones
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) async {
            switch (value) {
              case 'refresh':
                await _initIngredients();
                break;
              case 'test_notification':
                await NotificationService().showImmediateNotification(
                  id: 999,
                  title: '🔔 Prueba de Notificación',
                  body: 'Si ves esto, las notificaciones funcionan!',
                );
                if (mounted) {
                  _showSnackBar('Notificación de prueba enviada');
                }
                break;
              case 'info':
                _showInfoDialog();
                break;
              case 'stats':
                _showStatsDialog();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh, color: Colors.blue),
                  SizedBox(width: 12),
                  Text('Actualizar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'test_notification',
              child: Row(
                children: [
                  Icon(Icons.notifications_active, color: Colors.orange),
                  SizedBox(width: 12),
                  Text('Probar notificación'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'stats',
              child: Row(
                children: [
                  Icon(Icons.bar_chart, color: Colors.green),
                  SizedBox(width: 12),
                  Text('Ver estadísticas'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'info',
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey),
                  SizedBox(width: 12),
                  Text('Información'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  

  // Nuevo diálogo de estadísticas
  void _showStatsDialog() {
    final total = allIngredients.length;
    final available = allIngredients.where((i) => i.isAvailable && !i.isExpired()).length;
    final expiring = allIngredients.where((i) => i.isExpiringSoon(3) && !i.isExpired()).length;
    final expired = allIngredients.where((i) => i.isExpired()).length;
    final unavailable = allIngredients.where((i) => !i.isAvailable).length;

    // Contar por ubicación
    final byLocation = <String, int>{};
    for (var ing in allIngredients) {
      byLocation[ing.location] = (byLocation[ing.location] ?? 0) + 1;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.green),
            SizedBox(width: 12),
            Text('Estadísticas'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatRow('Total de ingredientes', total, Colors.blue),
              _buildStatRow('Disponibles', available, Colors.green),
              _buildStatRow('Por vencer', expiring, Colors.orange),
              _buildStatRow('Vencidos', expired, Colors.red),
              _buildStatRow('Agotados', unavailable, Colors.grey),
              
              if (byLocation.isNotEmpty) ...[
                const Divider(height: 24),
                const Text(
                  'Por ubicación:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...byLocation.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${entry.value}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(label),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              '$value',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Algo salió mal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage ?? 'Error desconocido',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _initIngredients,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: const Color.fromARGB(255, 9, 77, 133),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsList(
    List<KitchenIngredient> filteredIngredients,
    Map<String, List<KitchenIngredient>> ingredientsByLocation,
  ) {
    if (filteredIngredients.isEmpty) {
      return _buildEmptyState();
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: ingredientsByLocation.entries.map((entry) {
        return IngredientGroupWidget(
          location: entry.key,
          ingredients: entry.value,
          onRemoveIngredient: _removeIngredient,
          onEditIngredient: _showEditDialog,
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    final isFiltered = selectedFilter != 'Todos';
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFiltered ? Icons.filter_list_off : Icons.inventory_2_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isFiltered ? 'Sin resultados' : 'Despensa vacía',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isFiltered
                  ? 'No hay ingredientes con el filtro "$selectedFilter"'
                  : 'Aún no has agregado ingredientes a tu despensa',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!isFiltered)
              ElevatedButton.icon(
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add),
                label: const Text('Agregar primer ingrediente'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: const Color.fromARGB(255, 9, 77, 133),
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<KitchenIngredient> _getFilteredIngredients(List<KitchenIngredient> ingredients) {
    switch (selectedFilter) {
      case 'Disponibles':
        return ingredients
            .where((ing) => ing.isAvailable && !ing.isExpired())
            .toList();
      case 'Por vencer':
        return ingredients
            .where((ing) => ing.isExpiringSoon(3) && !ing.isExpired())
            .toList();
      case 'Vencidos':
        return ingredients.where((ing) => ing.isExpired()).toList();
      case 'Agotados':
        return ingredients.where((ing) => !ing.isAvailable).toList();
      default:
        return ingredients;
    }
  }

  Map<String, List<KitchenIngredient>> _groupIngredientsByLocation(
    List<KitchenIngredient> ingredients,
  ) {
    Map<String, List<KitchenIngredient>> grouped = {};

    for (var ingredient in ingredients) {
      if (!grouped.containsKey(ingredient.location)) {
        grouped[ingredient.location] = [];
      }
      grouped[ingredient.location]!.add(ingredient);
    }

    return grouped;
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AddIngredientDialog(
        onAdd: _addIngredient,
      ),
    );
  }

  void _showEditDialog(KitchenIngredient ingredient) {
    showDialog(
      context: context,
      builder: (context) => EditIngredientDialog(
        ingredient: ingredient,
        onUpdate: (updated) => _editIngredient(ingredient.name, updated),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 12),
            Text('Información'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem(Icons.check_circle, 'Disponible', Colors.green,
                'Ingrediente en buen estado'),
            _buildInfoItem(Icons.warning_amber, 'Por vencer', Colors.orange,
                'Vence en menos de 3 días'),
            _buildInfoItem(Icons.dangerous, 'Vencido', Colors.red,
                'Ya pasó su fecha de vencimiento'),
            _buildInfoItem(Icons.remove_circle, 'Agotado', Colors.grey,
                'No hay stock disponible'),
            const SizedBox(height: 16),
            const Text(
              'Toca un ingrediente para editarlo',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, Color color, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}