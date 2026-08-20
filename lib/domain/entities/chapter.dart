class Chapter {
  final String id;
  final int orden;
  final String titulo;
  final List<String> parrafos;
  final String? imagenUrl;
  final String? imagenSvgAsset;

  const Chapter({
    required this.id,
    required this.orden,
    required this.titulo,
    required this.parrafos,
    this.imagenUrl,
    this.imagenSvgAsset,
  });
}