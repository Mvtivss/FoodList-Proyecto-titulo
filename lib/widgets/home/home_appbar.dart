import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const HomeAppBar({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: screenHeight * 0.85,
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
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
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