import 'dart:math';
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  final Color color;
  final int cantidadParticulas;

  const ParticleBackground({
    super.key,
    required this.color,
    this.cantidadParticulas = 25,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _Particula {
  double x;
  double y;
  double radio;
  double velocidad;
  double opacidad;

  _Particula({
    required this.x,
    required this.y,
    required this.radio,
    required this.velocidad,
    required this.opacidad,
  });
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particula> _particulas = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    for (int i = 0; i < widget.cantidadParticulas; i++) {
      _particulas.add(
        _Particula(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          radio: _random.nextDouble() * 3 + 1,
          velocidad: _random.nextDouble() * 0.15 + 0.05,
          opacidad: _random.nextDouble() * 0.4 + 0.1,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ParticlePainter(
              particulas: _particulas,
              progreso: _controller.value,
              color: widget.color,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particula> particulas;
  final double progreso;
  final Color color;

  _ParticlePainter({
    required this.particulas,
    required this.progreso,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particula in particulas) {
      final desplazamiento = (progreso * particula.velocidad * 10) % 1.0;
      final yActual = (particula.y - desplazamiento) % 1.0;

      final paint = Paint()
        ..color = color.withValues(alpha: particula.opacidad)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particula.x * size.width, yActual * size.height),
        particula.radio,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}