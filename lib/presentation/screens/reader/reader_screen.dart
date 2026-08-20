import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/color_utils.dart';
import '../../providers/story_providers.dart';
import '../../widgets/chapter_page.dart';
import '../../widgets/particle_background.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final String storyId;

  const ReaderScreen({super.key, required this.storyId});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final PageController _pageController = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _currentPage = 0;
  String? _cancionActual;
  bool _musicaSilenciada = false;
  bool _marcadoComoLeido = false;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _reproducirCancion(String? url) async {
    if (url == null || url == _cancionActual) return;
    if (_disposed) return;

    _cancionActual = url;

    try {
      await _audioPlayer.stop();
      if (_disposed) return;

      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      if (_disposed) return;

      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      if (!_disposed) rethrow;
    }
  }

  Future<void> _alternarMusica() async {
    if (_disposed) return;
    setState(() => _musicaSilenciada = !_musicaSilenciada);
    if (_musicaSilenciada) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  void _irACapitulo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void _marcarComoLeidoSiNecesario(bool yaLeido) {
    if (yaLeido || _marcadoComoLeido) return;
    _marcadoComoLeido = true;
    ref.read(storyRepositoryProvider).markAsRead(widget.storyId);
  }

  @override
  Widget build(BuildContext context) {
    final storyAsync = ref.watch(storyByIdProvider(widget.storyId));

    return storyAsync.when(
      data: (story) {
        if (story == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Text(
                'Este cuento no existe',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_disposed) return;
          _reproducirCancion(story.cancionUrl);
          _marcarComoLeidoSiNecesario(story.leido);
        });

        final colorPrimario = Color(story.colorPrimario);
        final colorSecundario = Color(story.colorSecundario);
        final totalCapitulos = story.capitulos.length;

        // Fondo real que se ve detrás del contenido: mezcla del color
        // primario del cuento con el fondo base de la app.
        final fondoReal = Color.alphaBlend(
          colorPrimario.withValues(alpha: 0.14),
          AppColors.background,
        );

        // Color base para el texto de lectura: mezcla de los DOS colores
        // que elegiste al crear el cuento, ajustado automáticamente hasta
        // garantizar contraste real y legible contra el fondo que se ve.
        final colorBaseTexto = Color.lerp(colorPrimario, colorSecundario, 0.5)!;
        final colorTextoPrincipal = ColorUtils.colorContrastante(
          fondoReal,
          colorBaseTexto,
        );
        final colorTextoSecundario = colorTextoPrincipal.withValues(alpha: 0.7);
        final colorTextoHeader = ColorUtils.textoLegibleSobre(fondoReal);
        final colorIconos = ColorUtils.oscurecer(colorPrimario, 0.15);

        return Scaffold(
          backgroundColor: fondoReal,
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorPrimario.withValues(alpha: 0.18),
                        colorSecundario.withValues(alpha: 0.08),
                        AppColors.background,
                      ],
                    ),
                  ),
                ),
              ),
              ParticleBackground(color: colorPrimario),
              SafeArea(
                child: Column(
                  children: [
                    _buildHeader(
                      context,
                      story.titulo,
                      colorIconos,
                      colorTextoHeader,
                    ),
                    _buildProgresoCapitulos(
                      totalCapitulos,
                      colorPrimario,
                      colorSecundario,
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const PageScrollPhysics(),
                        itemCount: totalCapitulos,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemBuilder: (context, index) {
                          final capitulo = story.capitulos[index];
                          return FadeIn(
                            duration: const Duration(milliseconds: 400),
                            child: ChapterPage(
                              chapter: capitulo,
                              colorPrimario: colorPrimario,
                              colorSecundario: colorSecundario,
                              colorTexto: colorTextoPrincipal,
                              colorTextoSecundario: colorTextoSecundario,
                            ),
                          );
                        },
                      ),
                    ),
                    _buildNavegacionInferior(
                      colorPrimario,
                      colorSecundario,
                      colorIconos,
                      totalCapitulos,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryDark),
        ),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'No pudimos abrir este cuento 💔',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    String titulo,
    Color colorIconos,
    Color colorTexto,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorIconos),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              titulo,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: colorTexto,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(
              _musicaSilenciada
                  ? Icons.music_off_rounded
                  : Icons.music_note_rounded,
              color: colorIconos,
            ),
            onPressed: _alternarMusica,
          ),
        ],
      ),
    );
  }

  Widget _buildProgresoCapitulos(
    int total,
    Color colorPrimario,
    Color colorSecundario,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: List.generate(total, (index) {
          final activo = index <= _currentPage;
          return Expanded(
            child: GestureDetector(
              onTap: () => _irACapitulo(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: activo
                      ? LinearGradient(
                          colors: [colorPrimario, colorSecundario],
                        )
                      : null,
                  color: activo ? null : colorPrimario.withValues(alpha: 0.15),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavegacionInferior(
    Color colorPrimario,
    Color colorSecundario,
    Color colorIconos,
    int total,
  ) {
    final esUltimoCapitulo = _currentPage == total - 1;
    final esPrimerCapitulo = _currentPage == 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _botonNavegacion(
            icono: Icons.arrow_back_rounded,
            visible: !esPrimerCapitulo,
            color: colorIconos,
            onTap: () => _irACapitulo(_currentPage - 1),
          ),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [colorPrimario, colorSecundario],
            ).createShader(bounds),
            child: Text(
              'Capítulo ${_currentPage + 1} de $total',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          _botonNavegacion(
            icono: esUltimoCapitulo
                ? Icons.favorite_rounded
                : Icons.arrow_forward_rounded,
            visible: true,
            color: colorIconos,
            onTap: esUltimoCapitulo
                ? null
                : () => _irACapitulo(_currentPage + 1),
          ),
        ],
      ),
    );
  }

  Widget _botonNavegacion({
    required IconData icono,
    required bool visible,
    required Color color,
    VoidCallback? onTap,
  }) {
    if (!visible) return const SizedBox(width: 44, height: 44);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.15),
        ),
        child: Icon(icono, color: color, size: 20),
      ),
    );
  }
}