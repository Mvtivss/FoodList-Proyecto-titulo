import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/home/feature_button.dart';

class FeaturesGrid extends StatelessWidget {
  const FeaturesGrid({
    super.key,
    required this.features,
    required this.animationControllers,
    required this.scaleAnimations,
    required this.onButtonPressed,
  });

  final List<Map<String, dynamic>> features;
  final List<AnimationController> animationControllers;
  final List<Animation<double>> scaleAnimations;
  final Function(int, VoidCallback) onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.6,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: scaleAnimations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: scaleAnimations[index].value,
              child: FeatureButton(
                label: features[index]['label'] as String,
                icon: features[index]['icon'] as IconData,
                index: index,
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
}