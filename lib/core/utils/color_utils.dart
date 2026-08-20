import 'package:flutter/material.dart';

class ColorUtils {
  ColorUtils._();

  static Color textoLegibleSobre(Color fondo) {
    final luminancia = fondo.computeLuminance();
    return luminancia > 0.5
        ? const Color(0xFF2E2438)
        : const Color(0xFFFDFBFF);
  }

  static Color textoSecundarioSobre(Color fondo) {
    final base = textoLegibleSobre(fondo);
    return base.withValues(alpha: 0.75);
  }

  static Color oscurecer(Color color, double cantidad) {
    final hsl = HSLColor.fromColor(color);
    final hslOscuro = hsl.withLightness(
      (hsl.lightness - cantidad).clamp(0.0, 1.0),
    );
    return hslOscuro.toColor();
  }

  static Color aclarar(Color color, double cantidad) {
    final hsl = HSLColor.fromColor(color);
    final hslClaro = hsl.withLightness(
      (hsl.lightness + cantidad).clamp(0.0, 1.0),
    );
    return hslClaro.toColor();
  }

  static double _contraste(Color a, Color b) {
    final l1 = a.computeLuminance() + 0.05;
    final l2 = b.computeLuminance() + 0.05;
    return l1 > l2 ? l1 / l2 : l2 / l1;
  }

  static Color colorContrastante(
    Color fondo,
    Color colorBase, {
    double minContraste = 4.5,
  }) {
    final hsl = HSLColor.fromColor(colorBase);

    for (double l = hsl.lightness; l >= 0.0; l -= 0.04) {
      final candidato = hsl.withLightness(l).toColor();
      if (_contraste(candidato, fondo) >= minContraste) return candidato;
    }

    for (double l = hsl.lightness; l <= 1.0; l += 0.04) {
      final candidato = hsl.withLightness(l).toColor();
      if (_contraste(candidato, fondo) >= minContraste) return candidato;
    }

    return fondo.computeLuminance() > 0.5
        ? const Color(0xFF1A1424)
        : Colors.white;
  }
}