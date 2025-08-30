import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mapa simulado
          Container(
            color: Colors.grey[200],
            child: const Center(
              child: Text('Mapa Simulado', style: TextStyle(fontSize: 24, color: Colors.grey)),
            ),
          ),
          // Marcadores simulados
          Positioned(
            left: 100,
            top: 300,
            child: _buildMarker('Jumbo'),
          ),
          Positioned(
            right: 80,
            top: 250,
            child: _buildMarker('La Fábrica Patio Outlet'),
          ),
          Positioned(
            left: 150,
            bottom: 200,
            child: _buildMarker('Supermercado Líder'),
          ),
          // Barra superior personalizada
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.blue,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () {},
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          color: Colors.white,
                          child: const Text('MAPA', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          color: Colors.orange,
                          child: const Text('Usuario: Admin', style: TextStyle(color: Colors.white)),
                        ),
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.search),
                                SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Supermercados Cerca',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Icon(Icons.close),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber),
                              SizedBox(width: 4),
                              Text('Locales favoritos'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarker(String title) {
    return Column(
      children: [
        const Icon(Icons.location_on, color: Colors.red, size: 30),
        Container(
          padding: const EdgeInsets.all(4),
          color: Colors.white,
          child: Text(title, style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
