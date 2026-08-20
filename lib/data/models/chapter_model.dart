import '../../domain/entities/chapter.dart';

class ChapterModel extends Chapter {
  const ChapterModel({
    required super.id,
    required super.orden,
    required super.titulo,
    required super.parrafos,
    super.imagenUrl,
    super.imagenSvgAsset,
  });

  factory ChapterModel.fromMap(Map<String, dynamic> map) {
    return ChapterModel(
      id: map['id'] as String,
      orden: map['orden'] as int,
      titulo: map['titulo'] as String,
      parrafos: List<String>.from(map['parrafos'] as List),
      imagenUrl: map['imagenUrl'] as String?,
      imagenSvgAsset: map['imagenSvgAsset'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orden': orden,
      'titulo': titulo,
      'parrafos': parrafos,
      'imagenUrl': imagenUrl,
      'imagenSvgAsset': imagenSvgAsset,
    };
  }
}