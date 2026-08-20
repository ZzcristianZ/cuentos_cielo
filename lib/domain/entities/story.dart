import 'chapter.dart';

class Story {
  final String id;
  final String titulo;
  final String? descripcion;
  final String? portadaUrl;
  final String? cancionUrl;
  final int colorPrimario;
  final int colorSecundario;
  final DateTime fechaCreacion;
  final List<Chapter> capitulos;
  final bool leido;

  const Story({
    required this.id,
    required this.titulo,
    this.descripcion,
    this.portadaUrl,
    this.cancionUrl,
    required this.colorPrimario,
    required this.colorSecundario,
    required this.fechaCreacion,
    required this.capitulos,
    this.leido = false,
  });
}