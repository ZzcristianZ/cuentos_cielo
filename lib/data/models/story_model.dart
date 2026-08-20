import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/story.dart';
import 'chapter_model.dart';

class StoryModel extends Story {
  const StoryModel({
    required super.id,
    required super.titulo,
    super.descripcion,
    super.portadaUrl,
    super.cancionUrl,
    required super.colorPrimario,
    required super.colorSecundario,
    required super.fechaCreacion,
    required super.capitulos,
    super.leido,
  });

  factory StoryModel.fromFirestore(String id, Map<String, dynamic> data) {
    final capitulosData = (data['capitulos'] as List<dynamic>? ?? [])
        .map((c) => ChapterModel.fromMap(c as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.orden.compareTo(b.orden));

    return StoryModel(
      id: id,
      titulo: data['titulo'] as String? ?? 'Sin título',
      descripcion: data['descripcion'] as String?,
      portadaUrl: data['portadaUrl'] as String?,
      cancionUrl: data['cancionUrl'] as String?,
      colorPrimario: data['colorPrimario'] as int? ?? 0xFFB39DDB,
      colorSecundario: data['colorSecundario'] as int? ?? 0xFFF48FB1,
      fechaCreacion: (data['fechaCreacion'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      capitulos: capitulosData,
      leido: data['leido'] as bool? ?? false,
    );
  }
}