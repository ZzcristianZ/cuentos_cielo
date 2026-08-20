import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/library/library_screen.dart';
import '../../presentation/screens/reader/reader_screen.dart';
import '../../presentation/widgets/page_transition_wrapper.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        pageBuilder: (context, state) => PageTransitionWrapper.build(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/biblioteca',
        name: 'biblioteca',
        pageBuilder: (context, state) => PageTransitionWrapper.build(
          key: state.pageKey,
          child: const LibraryScreen(),
        ),
      ),
      GoRoute(
        path: '/cuento/:id',
        name: 'cuento',
        pageBuilder: (context, state) {
          final storyId = state.pathParameters['id']!;
          return PageTransitionWrapper.build(
            key: state.pageKey,
            child: ReaderScreen(storyId: storyId),
          );
        },
      ),
    ],
  );
}