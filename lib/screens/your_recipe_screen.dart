import 'package:flutter/material.dart';

class YourRecipesScreen extends StatefulWidget {
  const YourRecipesScreen({super.key});

  @override
  State<YourRecipesScreen> createState() => _YourRecipesScreenState();
}

class _YourRecipesScreenState extends State<YourRecipesScreen> {
  List<UserRecipe> userRecipes = [];
  String searchQuery = '';
  String selectedCategory = 'Todas';

  final List<String> categories = [
    'Todas', 'Desayuno', 'Almuerzo', 'Cena', 'Postre', 'Snack', 'Bebida'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserRecipes();
  }

  void _loadUserRecipes() {
    // Simular recetas del usuario
    userRecipes = [
      UserRecipe(
        id: '1',
        name: 'Mi Pasta Especial',
        description: 'Una receta familiar que he perfeccionado',
        category: 'Almuerzo',
        difficulty: 'Medio',
        prepTime: 25,
        servings: 4,
        ingredients: [
          RecipeIngredient(name: 'Pasta', quantity: '400g'),
          RecipeIngredient(name: 'Tomate', quantity: '3 unidades'),
          RecipeIngredient(name: 'Ajo', quantity: '2 dientes'),
          RecipeIngredient(name: 'Queso', quantity: '100g'),
        ],
        instructions: [
          'Hervir agua con sal para la pasta',
          'Cocinar la pasta según las instrucciones',
          'Hacer sofrito con ajo y tomate',
          'Mezclar pasta con el sofrito',
          'Agregar queso rallado y servir'
        ],
        tags: ['Italiana', 'Fácil', 'Familiar'],
        dateCreated: DateTime.now().subtract(const Duration(days: 5)),
        rating: 4.5,
        timesCooked: 8,
        isFavorite: true,
      ),
      UserRecipe(
        id: '2',
        name: 'Smoothie Energético',
        description: 'Mi bebida favorita para empezar el día',
        category: 'Bebida',
        difficulty: 'Muy Fácil',
        prepTime: 5,
        servings: 1,
        ingredients: [
          RecipeIngredient(name: 'Plátano', quantity: '1 unidad'),
          RecipeIngredient(name: 'Yogur', quantity: '150ml'),
          RecipeIngredient(name: 'Miel', quantity: '1 cucharada'),
          RecipeIngredient(name: 'Avena', quantity: '2 cucharadas'),
        ],
        instructions: [
          'Pelar y cortar el plátano',
          'Agregar todos los ingredientes a la licuadora',
          'Licuar por 1 minuto hasta que esté suave',
          'Servir inmediatamente'
        ],
        tags: ['Saludable', 'Desayuno', 'Rápido'],
        dateCreated: DateTime.now().subtract(const Duration(days: 12)),
        rating: 5.0,
        timesCooked: 15,
        isFavorite: true,
      ),
      UserRecipe(
        id: '3',
        name: 'Ensalada César Casera',
        description: 'Mi versión de la clásica ensalada',
        category: 'Almuerzo',
        difficulty: 'Fácil',
        prepTime: 15,
        servings: 2,
        ingredients: [
          RecipeIngredient(name: 'Lechuga', quantity: '1 unidad'),
          RecipeIngredient(name: 'Pan', quantity: '2 rebanadas'),
          RecipeIngredient(name: 'Queso', quantity: '50g'),
          RecipeIngredient(name: 'Aceite de oliva', quantity: '3 cucharadas'),
        ],
        instructions: [
          'Lavar y cortar la lechuga',
          'Hacer crutones con el pan',
          'Preparar aderezo César',
          'Mezclar todos los ingredientes',
          'Servir con queso rallado'
        ],
        tags: ['Ensalada', 'Saludable', 'Clásico'],
        dateCreated: DateTime.now().subtract(const Duration(days: 20)),
        rating: 4.0,
        timesCooked: 3,
        isFavorite: false,
      ),
    ];
  }

  List<UserRecipe> get filteredRecipes {
    return userRecipes.where((recipe) {
      bool matchesSearch = recipe.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          recipe.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          recipe.tags.any((tag) => tag.toLowerCase().contains(searchQuery.toLowerCase()));
      
      bool matchesCategory = selectedCategory == 'Todas' || recipe.category == selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        title: const Text(
          'FOODLIST - Tus Recetas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 9, 77, 133),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: _showSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          // Estadísticas del usuario
          _buildUserStats(),
          
          // Filtros por categoría
          _buildCategoryFilters(),
          
          // Lista de recetas
          Expanded(
            child: filteredRecipes.isEmpty 
              ? _buildEmptyState() 
              : _buildRecipesList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewRecipe,
        backgroundColor: const Color.fromARGB(255, 9, 77, 133),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Receta'),
      ),
    );
  }

  Widget _buildUserStats() {
    int totalRecipes = userRecipes.length;
    int favoriteRecipes = userRecipes.where((r) => r.isFavorite).length;
    double avgRating = userRecipes.isEmpty ? 0.0 : 
        userRecipes.map((r) => r.rating).reduce((a, b) => a + b) / totalRecipes;
    int totalTimesCooked = userRecipes.map((r) => r.timesCooked).fold(0, (a, b) => a + b);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 9, 77, 133), Color.fromARGB(255, 119, 161, 158)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Tu Colección de Recetas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatItem('Recetas', totalRecipes.toString(), Icons.book)),
              Expanded(child: _buildStatItem('Favoritas', favoriteRecipes.toString(), Icons.favorite)),
              Expanded(child: _buildStatItem('Rating', avgRating.toStringAsFixed(1), Icons.star)),
              Expanded(child: _buildStatItem('Cocinadas', totalTimesCooked.toString(), Icons.restaurant)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          String category = categories[index];
          bool isSelected = selectedCategory == category;
          
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = category;
                });
              },
              selectedColor: const Color.fromARGB(255, 119, 161, 158),
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            searchQuery.isNotEmpty 
              ? 'No se encontraron recetas' 
              : '¡Crea tu primera receta!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isNotEmpty 
              ? 'Prueba con otros términos de búsqueda'
              : 'Guarda tus recetas favoritas y accede a ellas cuando quieras',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (searchQuery.isEmpty) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _addNewRecipe,
              icon: const Icon(Icons.add),
              label: const Text('Crear Receta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 9, 77, 133),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecipesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredRecipes.length,
      itemBuilder: (context, index) {
        return _buildRecipeCard(filteredRecipes[index]);
      },
    );
  }

  Widget _buildRecipeCard(UserRecipe recipe) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con rating y favorito
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 9, 77, 133),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        recipe.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          recipe.rating.toString(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: recipe.isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () => _toggleFavorite(recipe),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Contenido de la receta
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información básica
                Row(
                  children: [
                    _buildInfoChip(Icons.schedule, '${recipe.prepTime} min', Colors.blue),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.people, '${recipe.servings} pers.', Colors.green),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.signal_cellular_alt, recipe.difficulty, _getDifficultyColor(recipe.difficulty)),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Tags
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: recipe.tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 119, 161, 158).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 119, 161, 158),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )).toList(),
                ),
                
                const SizedBox(height: 12),
                
                // Estadísticas de uso
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.restaurant, color: Colors.grey[600], size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Cocinada ${recipe.timesCooked} veces',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.calendar_today, color: Colors.grey[600], size: 16),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(recipe.dateCreated),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewRecipe(recipe),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('Ver Receta'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(255, 9, 77, 133),
                          side: const BorderSide(color: Color.fromARGB(255, 9, 77, 133)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _cookRecipe(recipe),
                        icon: const Icon(Icons.restaurant, size: 16),
                        label: const Text('Cocinar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 119, 161, 158),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _editRecipe(recipe),
                      icon: const Icon(Icons.edit, color: Color.fromARGB(255, 9, 77, 133)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Muy Fácil':
        return Colors.green;
      case 'Fácil':
        return Colors.lightGreen;
      case 'Medio':
        return Colors.orange;
      case 'Difícil':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: RecipeSearchDelegate(userRecipes),
    );
  }

  void _toggleFavorite(UserRecipe recipe) {
    setState(() {
      recipe.isFavorite = !recipe.isFavorite;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          recipe.isFavorite 
            ? '${recipe.name} agregada a favoritas' 
            : '${recipe.name} removida de favoritas'
        ),
        backgroundColor: recipe.isFavorite ? Colors.green : Colors.orange,
      ),
    );
  }

  void _viewRecipe(UserRecipe recipe) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 9, 77, 133),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        recipe.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      
                      // Información básica
                      Row(
                        children: [
                          _buildInfoChip(Icons.schedule, '${recipe.prepTime} min', Colors.blue),
                          const SizedBox(width: 8),
                          _buildInfoChip(Icons.people, '${recipe.servings} personas', Colors.green),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Ingredientes
                      const Text(
                        'Ingredientes:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...recipe.ingredients.map((ingredient) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.circle, size: 8, color: Color.fromARGB(255, 9, 77, 133)),
                            const SizedBox(width: 8),
                            Text('${ingredient.quantity} ${ingredient.name}'),
                          ],
                        ),
                      )),
                      
                      const SizedBox(height: 20),
                      
                      // Instrucciones
                      const Text(
                        'Instrucciones:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...recipe.instructions.asMap().entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 9, 77, 133),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${entry.key + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(entry.value)),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _cookRecipe(UserRecipe recipe) {
    setState(() {
      recipe.timesCooked++;
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.restaurant, color: Colors.orange),
            const SizedBox(width: 8),
            Text('¡A cocinar ${recipe.name}!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Cómo te quedó la receta?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) => 
                IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < recipe.rating ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      recipe.rating = index + 1.0;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('¡Gracias por calificar ${recipe.name}!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
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

  void _editRecipe(UserRecipe recipe) {
    _showRecipeForm(recipe: recipe);
  }

  void _addNewRecipe() {
    _showRecipeForm();
  }

  void _showRecipeForm({UserRecipe? recipe}) {
    final nameController = TextEditingController(text: recipe?.name ?? '');
    final descriptionController = TextEditingController(text: recipe?.description ?? '');
    final prepTimeController = TextEditingController(text: recipe?.prepTime.toString() ?? '');
    final servingsController = TextEditingController(text: recipe?.servings.toString() ?? '');
    
    String selectedCategory = recipe?.category ?? categories[1];
    String selectedDifficulty = recipe?.difficulty ?? 'Fácil';
    List<RecipeIngredient> ingredients = List.from(recipe?.ingredients ?? []);
    List<String> instructions = List.from(recipe?.instructions ?? []);
    List<String> tags = List.from(recipe?.tags ?? []);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 700, maxWidth: 400),
          child: StatefulBuilder(
            builder: (context, setDialogState) => Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 9, 77, 133),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          recipe == null ? 'Nueva Receta' : 'Editar Receta',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                
                // Contenido del formulario
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre de la receta',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        TextField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Descripción',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: selectedCategory,
                                decoration: const InputDecoration(
                                  labelText: 'Categoría',
                                  border: OutlineInputBorder(),
                                ),
                                items: categories.skip(1).map((cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                )).toList(),
                                onChanged: (value) {
                                  setDialogState(() {
                                    selectedCategory = value!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: selectedDifficulty,
                                decoration: const InputDecoration(
                                  labelText: 'Dificultad',
                                  border: OutlineInputBorder(),
                                ),
                                items: ['Muy Fácil', 'Fácil', 'Medio', 'Difícil']
                                    .map((diff) => DropdownMenuItem(
                                  value: diff,
                                  child: Text(diff),
                                )).toList(),
                                onChanged: (value) {
                                  setDialogState(() {
                                    selectedDifficulty = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: prepTimeController,
                                decoration: const InputDecoration(
                                  labelText: 'Tiempo (min)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: servingsController,
                                decoration: const InputDecoration(
                                  labelText: 'Porciones',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        
                        // Aquí continuarían los campos para ingredientes, instrucciones y tags
                        // Por brevedad, se omiten pero seguirían el mismo patrón
                      ],
                    ),
                  ),
                ),
                
                // Botones de acción
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      if (recipe != null)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _deleteRecipe(recipe);
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text('Eliminar'),
                          ),
                        ),
                      if (recipe != null) const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _saveRecipe(
                              recipe?.id,
                              nameController.text,
                              descriptionController.text,
                              selectedCategory,
                              selectedDifficulty,
                              int.tryParse(prepTimeController.text) ?? 0,
                              int.tryParse(servingsController.text) ?? 1,
                              ingredients,
                              instructions,
                              tags,
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 9, 77, 133),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(recipe == null ? 'Crear' : 'Guardar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveRecipe(String? id, String name, String description, String category, 
      String difficulty, int prepTime, int servings, List<RecipeIngredient> ingredients,
      List<String> instructions, List<String> tags) {
    
    if (name.isEmpty) return;

    setState(() {
      if (id != null) {
        // Editar receta existente
        int index = userRecipes.indexWhere((r) => r.id == id);
        if (index != -1) {
          userRecipes[index] = UserRecipe(
            id: id,
            name: name,
            description: description,
            category: category,
            difficulty: difficulty,
            prepTime: prepTime,
            servings: servings,
            ingredients: ingredients,
            instructions: instructions,
            tags: tags,
            dateCreated: userRecipes[index].dateCreated,
            rating: userRecipes[index].rating,
            timesCooked: userRecipes[index].timesCooked,
            isFavorite: userRecipes[index].isFavorite,
          );
        }
      } else {
        // Crear nueva receta
        userRecipes.add(UserRecipe(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          description: description,
          category: category,
          difficulty: difficulty,
          prepTime: prepTime,
          servings: servings,
          ingredients: ingredients,
          instructions: instructions,
          tags: tags,
          dateCreated: DateTime.now(),
          rating: 0.0,
          timesCooked: 0,
          isFavorite: false,
        ));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(id == null ? 'Receta creada exitosamente' : 'Receta actualizada'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteRecipe(UserRecipe recipe) {
    setState(() {
      userRecipes.removeWhere((r) => r.id == recipe.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${recipe.name} eliminada'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              userRecipes.add(recipe);
            });
          },
        ),
      ),
    );
  }
}

// Clases de modelo
class UserRecipe {
  final String id;
  String name;
  String description;
  String category;
  String difficulty;
  int prepTime;
  int servings;
  List<RecipeIngredient> ingredients;
  List<String> instructions;
  List<String> tags;
  DateTime dateCreated;
  double rating;
  int timesCooked;
  bool isFavorite;

  UserRecipe({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.prepTime,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    required this.tags,
    required this.dateCreated,
    required this.rating,
    required this.timesCooked,
    required this.isFavorite,
  });
}

class RecipeIngredient {
  String name;
  String quantity;

  RecipeIngredient({
    required this.name,
    required this.quantity,
  });
}

// Delegado de búsqueda
class RecipeSearchDelegate extends SearchDelegate<UserRecipe?> {
  final List<UserRecipe> recipes;

  RecipeSearchDelegate(this.recipes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredRecipes = recipes.where((recipe) {
      return recipe.name.toLowerCase().contains(query.toLowerCase()) ||
             recipe.description.toLowerCase().contains(query.toLowerCase()) ||
             recipe.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();

    return ListView.builder(
      itemCount: filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = filteredRecipes[index];
        return ListTile(
          title: Text(recipe.name),
          subtitle: Text(recipe.description),
          leading: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 9, 77, 133),
            child: Text(recipe.name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
          ),
          onTap: () => close(context, recipe),
        );
      },
    );
  }
}