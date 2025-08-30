import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/virtual_assistant_chat.dart';
class FloatingAssistantButton extends StatefulWidget {
  const FloatingAssistantButton({super.key});

  @override
  State<FloatingAssistantButton> createState() => _FloatingAssistantButtonState();
}

class _FloatingAssistantButtonState extends State<FloatingAssistantButton>
    with TickerProviderStateMixin {
  late Offset _position;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    
    // Posición inicial (esquina inferior derecha)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        _position = Offset(size.width - 80, size.height - 200);
      });
    });

    // Animación de pulso
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Animación de brillo
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Iniciar animaciones
    _pulseController.repeat(reverse: true);
    _glowController.repeat(reverse: true);

    // Posición inicial por defecto
    _position = const Offset(300, 600);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position = Offset(
        _position.dx + details.delta.dx,
        _position.dy + details.delta.dy,
      );
    });
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });
    _snapToEdge();
  }

  void _snapToEdge() {
    final screenSize = MediaQuery.of(context).size;
    final buttonSize = 60.0;
    final margin = 20.0;

    double newX = _position.dx;
    double newY = _position.dy;

    // Limitar a los bordes de la pantalla
    if (newX < margin) {
      newX = margin;
    } else if (newX > screenSize.width - buttonSize - margin) {
      newX = screenSize.width - buttonSize - margin;
    }

    if (newY < 100) {
      newY = 100;
    } else if (newY > screenSize.height - buttonSize - 100) {
      newY = screenSize.height - buttonSize - 100;
    }

    // Animar hacia la nueva posición
    setState(() {
      _position = Offset(newX, newY);
    });
  }

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VirtualAssistantChat(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onTap: _openChat,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _glowAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _isDragging ? 1.1 : _pulseAnimation.value,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.purple,
                      Colors.deepPurple,
                      Colors.indigo,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3 + (_glowAnimation.value * 0.3)),
                      spreadRadius: 2 + (_glowAnimation.value * 4),
                      blurRadius: 8 + (_glowAnimation.value * 8),
                      offset: const Offset(0, 2),
                    ),
                    if (_isDragging)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Icono principal
                    const Icon(
                      Icons.smart_toy_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    
                    // Indicador de notificación (opcional)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 0.8 + (_glowAnimation.value * 0.4),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}