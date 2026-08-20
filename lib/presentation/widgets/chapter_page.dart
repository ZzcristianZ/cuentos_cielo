import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../domain/entities/chapter.dart';

class ChapterPage extends StatelessWidget {
  final Chapter chapter;
  final Color colorPrimario;
  final Color colorSecundario;
  final Color colorTexto;
  final Color colorTextoSecundario;

  const ChapterPage({
    super.key,
    required this.chapter,
    required this.colorPrimario,
    required this.colorSecundario,
    required this.colorTexto,
    required this.colorTextoSecundario,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [colorPrimario, colorSecundario],
            ).createShader(bounds),
            child: Text(
              chapter.titulo,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          const SizedBox(height: 20),
          if (chapter.imagenSvgAsset != null)
            Center(
              child: SvgPicture.asset(
                chapter.imagenSvgAsset!,
                height: 180,
              ),
            )
          else if (chapter.imagenUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: colorPrimario.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CachedNetworkImage(
                    imageUrl: chapter.imagenUrl!,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 400),
                    fadeInCurve: Curves.easeOut,
                    placeholder: (context, url) => _buildPlaceholder(),
                    errorWidget: (context, url, error) => Container(
                      color: colorPrimario.withValues(alpha: 0.15),
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        color: colorPrimario,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 28),
          ...chapter.parrafos.map(
            (parrafo) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Text(
                parrafo,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.7,
                  color: colorTexto,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.swipe_rounded,
                  color: colorTextoSecundario,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  'Desliza para cambiar de capítulo',
                  style: TextStyle(
                    color: colorTextoSecundario,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Shimmer.fromColors(
      baseColor: colorPrimario.withValues(alpha: 0.12),
      highlightColor: colorPrimario.withValues(alpha: 0.25),
      period: const Duration(milliseconds: 1400),
      child: Container(
        color: colorPrimario.withValues(alpha: 0.15),
      ),
    );
  }
}