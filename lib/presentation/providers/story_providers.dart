import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/firestore_service.dart';
import '../../data/repositories/story_repository_impl.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/story_repository.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepositoryImpl(ref.watch(firestoreServiceProvider));
});

final storiesStreamProvider = StreamProvider<List<Story>>((ref) {
  return ref.watch(storyRepositoryProvider).watchStories();
});
final storyByIdProvider =
    FutureProvider.family<Story?, String>((ref, storyId) {
  return ref.watch(storyRepositoryProvider).getStoryById(storyId);
});