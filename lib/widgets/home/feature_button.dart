import 'package:flutter/material.dart';

class FeatureButton extends StatelessWidget {
  const FeatureButton({
    super.key,
    required this.label,
    required this.icon,
    required this.index,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final int index;
  final VoidCallback onPressed;

  // Colores llamativos para cada botón
  static const List<List<Color>> gradientColors = [
    [Color(0xFFFF6B6B), Color(0xFFEE5A52)], // Rojo coral vibrante
    [Color(0xFF4ECDC4), Color(0xFF44A08D)], // Turquesa a verde agua
    [Color(0xFFFFBE0B), Color(0xFFFB8500)], // Amarillo a naranja
    [Color(0xFF8B5CF6), Color(0xFFA78BFA)], // Púrpura vibrante
  ];

  static const List<Color> shadowColors = [
    Color(0xFFFF6B6B), // Sombra roja
    Color(0xFF4ECDC4), // Sombra turquesa
    Color(0xFFFFBE0B), // Sombra amarilla
    Color(0xFF8B5CF6), // Sombra púrpura
  ];

  @override
  Widget build(BuildContext context) {
    final gradient = gradientColors[index % gradientColors.length];
    final shadowColor = shadowColors[index % shadowColors.length];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            spreadRadius: -2,
            blurRadius: 8,
            offset: const Offset(-2, -2),
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
          highlightColor: Colors.white.withOpacity(0.2),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 2,
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
}