import 'package:flutter/material.dart';

class HomeFooterWidget extends StatelessWidget {
  const HomeFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
}