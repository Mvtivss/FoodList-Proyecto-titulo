import 'package:flutter/material.dart';

class SearchIngredientBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchIngredientBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScaler = MediaQuery.textScalerOf(context).scale(1);
    
    return SearchBar(
      controller: controller,
      onChanged: onChanged,
      constraints: BoxConstraints.expand(height: 40, width: screenWidth * 0.9),
      hintStyle: WidgetStatePropertyAll(TextStyle(fontSize: 8 * textScaler)),
      hintText: 'Buscar ingrediente o ubicación',
      backgroundColor: WidgetStatePropertyAll(Colors.grey[300]),
      elevation: const WidgetStatePropertyAll(0),
      leading: const Icon(Icons.search),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }
}