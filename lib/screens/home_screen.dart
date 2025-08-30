import 'package:flutter_application_1/screens/kitche_inventory_screen.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/shopping_list_screen.dart';
import 'package:flutter_application_1/widgets/floating_assistant_button.dart'; // Importar el nuevo widget
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              SizedBox(height: screenHeight * 0.25), // Espacio para los botones sobrepuestos
             
              _buildGridFeatures(context, screenHeight, screenWidth),
              _buildFooter(),
            ],
          ),
          BuildAppBar(screenWidth: screenWidth, screenHeight: screenHeight),
          _buildFeatureButtonsRow(context, screenWidth, screenHeight),
          
          // Botón flotante del asistente virtual
          const FloatingAssistantButton(),
        ],
      ),
    );
  }

  Widget _buildFeatureButtonsRow(BuildContext context, double screenWidth, double screenHeight) {
    return Positioned(
      top: screenHeight * 0.070,
      left: screenWidth * 0.18,
      right: screenWidth * 0.18,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFeatureButton(
            icon: Icons.kitchen,
            label: 'Tu Cocina',
            color: const Color.fromARGB(255, 184, 110, 84),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KitchenInventoryScreen()),
              );
            },
          ),
          _buildFeatureButton(
            icon: Icons.restaurant_menu,
            label: 'Tus recetas',
            color: const Color.fromARGB(255, 117, 64, 45),
            onPressed: () {},
          ),
          _buildFeatureButton(
            icon: Icons.person,
            label: 'Perfil',
            color: const Color.fromARGB(255, 184, 110, 84),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildGridFeatures(BuildContext context, screenHeight, screenWidth) {
    return GridView.count(
      childAspectRatio: 1 / 1.4,
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: [
        
        _buildMapFeature(
          label: 'Lista de Compras',
          icon: Icons.list,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ShoppingListScreen()));
          },
        ),
        _buildMapFeature(
          label: 'Recetas recomendadas',
          icon: Icons.restaurant,
          onPressed: () {},
        ),
        _buildMapFeature(
          label: 'Horario',
          icon: Icons.schedule,
          onPressed: () {},
        ),
        _buildMapFeature(
          label: 'Recomendaciones',
          icon: Icons.recommend,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color.fromARGB(255, 9, 77, 133)),
        padding: const EdgeInsets.all(2),
        width: double.infinity,
        //color: const Color.fromARGB(255, 9, 77, 133),
        child: const Text(
          'Crea el horario que más te acomode',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFeatureButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return LayoutBuilder(builder: (context, constraits) {
      // Obtenemos el tamaño de la pantalla
      final screenSize = MediaQuery.of(context).size;

      // Calculamos las dimensiones proporcionales
      final height = screenSize.height * 0.17; // 17% de la altura de la pantalla
      final width = screenSize.width * 0.18; // 18% del ancho de la pantalla
      return InkWell(
        onTap: onPressed,
        child: Container(
          margin: const EdgeInsets.all(6),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: width * 0.5),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    });
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
      ),
      margin: const EdgeInsets.all(1),
      child: InkWell(
        onTap: onPressed,
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
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
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
      bottom: screenHeight * 0.80,
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
          Text('Usuario: Admin', style: TextStyle(color: Colors.white, fontSize: 15)),
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
      children: const <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 9, 77, 133),
          ),
          child: Text(
            'Recetas Favoritas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.star, color: Colors.yellow),
          title: Text('Spaguettis a la Boloñesa'),
        ),
        ListTile(
          leading: Icon(Icons.star, color: Colors.yellow),
          title: Text('Rissoto de Champiñones'),
        ),
        ListTile(
          leading: Icon(Icons.star, color: Colors.yellow),
          title: Text('Pastel de Chocolate'),
        ),
        ListTile(
          leading: Icon(Icons.star, color: Colors.yellow),
          title: Text('Ensalada César'),
        ),
      ],
    ),
  );
}