import 'package:flutter/material.dart';

class FeaturesGridWidget extends StatelessWidget {
  final List<AnimationController> animationControllers;
  final List<Animation<double>> scaleAnimations;
  final Function(int, VoidCallback) onButtonPressed;
  final VoidCallback onShoppingListPressed;
  final VoidCallback onVirtualAssistantPressed;

  const FeaturesGridWidget({
    super.key,
    required this.animationControllers,
    required this.scaleAnimations,
    required this.onButtonPressed,
    required this.onShoppingListPressed,
    required this.onVirtualAssistantPressed,
  });

  @override
  Widget build(BuildContext context) {
    final features = _getFeaturesList();

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
          animation: scaleAnimations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: scaleAnimations[index].value,
              child: _FeatureCard(
                label: features[index]['label'] as String,
                icon: features[index]['icon'] as IconData,
                onPressed: () => onButtonPressed(
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

  List<Map<String, dynamic>> _getFeaturesList() {
    return [
      {
        'label': 'Lista de Compras',
        'icon': Icons.list,
        'onPressed': onShoppingListPressed,
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
        'onPressed': onVirtualAssistantPressed,
      },
    ];
  }
}

class _FeatureCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _FeatureCard({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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