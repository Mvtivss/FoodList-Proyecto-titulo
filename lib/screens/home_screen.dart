import 'package:flutter_application_1/screens/kitche_inventory_screen.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/shopping_list_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    // Crear controladores de animación para cada botón principal
    _animationControllers = List.generate(
      4,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: this,
      ),
    );

    // Crear animaciones de escala
    _scaleAnimations = _animationControllers
        .map((controller) => Tween<double>(
              begin: 1.0,
              end: 0.95,
            ).animate(CurvedAnimation(
              parent: controller,
              curve: Curves.easeInOut,
            )))
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onButtonPressed(int index, VoidCallback onPressed) async {
    await _animationControllers[index].forward();
    await _animationControllers[index].reverse();
    onPressed();
  }

  void _showVirtualAssistant() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Asistente Virtual',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 9, 77, 133),
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.smart_toy,
                        size: 80,
                        color: Color.fromARGB(255, 9, 77, 133),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '¡Hola! Soy tu asistente virtual',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '¿En qué puedo ayudarte hoy?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: screenHeight * 0.15), // Reducido el espacio
              _buildGridFeatures(context, screenHeight, screenWidth),
              _buildFooter(),
            ],
          ),
          BuildAppBar(screenWidth: screenWidth, screenHeight: screenHeight),
        ],
      ),
    );
  }

  Widget _buildGridFeatures(BuildContext context, screenHeight, screenWidth) {
    final features = [
      {
        'label': 'Lista de Compras',
        'icon': Icons.list,
        'onPressed': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShoppingListScreen()),
          );
        },
      },
      {
        'label': 'Recetas recomendadas',
        'icon': Icons.restaurant,
        'onPressed': () {},
      },
      {
        'label': 'Horario',
        'icon': Icons.schedule,
        'onPressed': () {},
      },
      {
        'label': 'Recomendaciones',
        'icon': Icons.recommend,
        'onPressed': () => _showVirtualAssistant(),
      },
    ];

    return GridView.builder(
      
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.4,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _scaleAnimations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimations[index].value,
              child: _buildMapFeature(
                label: features[index]['label'] as String,
                icon: features[index]['icon'] as IconData,
                onPressed: () => _onButtonPressed(
                  index,
                  features[index]['onPressed'] as VoidCallback,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 9, 77, 133),
        ),
        padding: const EdgeInsets.all(2),
        width: double.infinity,
        child: const Text(
          'Crea el horario que más te acomode',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMapFeature({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color.fromARGB(255, 119, 161, 158),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.all(8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 65,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildAppBar extends StatelessWidget {
  const BuildAppBar({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: screenHeight * 0.85, // Ajustado para menos altura
      left: 0,
      right: 0,
      child: AppBar(
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
        backgroundColor: const Color.fromARGB(255, 9, 77, 133),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
        ),
        title: const Text(
          'INICIO',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        actions: const [
          Text(
            'Usuario: Admin',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Icon(
            Icons.person,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

Widget _buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 9, 77, 133),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Menú Principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Accesos rápidos',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        // Opciones principales movidas desde los botones superiores
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 184, 110, 84),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.kitchen, color: Colors.white, size: 20),
          ),
          title: const Text(
            'Tu Cocina',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          onTap: () {
            Navigator.pop(context); // Cerrar drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KitchenInventoryScreen()),
            );
          },
        ),
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 117, 64, 45),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 20),
          ),
          title: const Text(
            'Tus Recetas',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          onTap: () {
            Navigator.pop(context);
            // Agregar navegación a la pantalla de recetas
          },
        ),
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 184, 110, 84),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
          title: const Text(
            'Perfil',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
        const Divider(),
        // Sección de recetas favoritas
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Recetas Favoritas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 9, 77, 133),
            ),
          ),
        ),
        const ListTile(
          leading: Icon(Icons.star, color: Colors.yellow),
          title: Text('Spaguettis a la Boloñesa'),
        ),
        const ListTile(
          leading: Icon(Icons.star, color: Colors.yellow),
          title: Text('Rissoto de Champiñones'),
        ),
        const ListTile(
          leading: Icon(Icons.star, color: Colors.yellow),
          title: Text('Pastel de Chocolate'),
        ),
        const ListTile(
          leading: Icon(Icons.star, color: Colors.yellow),
          title: Text('Ensalada César'),
        ),
      ],
    ),
  );
}