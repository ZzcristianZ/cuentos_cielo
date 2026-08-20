import '../../domain/entities/story.dart';
import '../../domain/repositories/story_repository.dart';
import '../services/firestore_service.dart';

class StoryRepositoryImpl implements StoryRepository {
  final FirestoreService _firestoreService;

  StoryRepositoryImpl(this._firestoreService);

  @override
  Stream<List<Story>> watchStories() {
    return _firestoreService.watchStories();
  }

  @override
  Future<Story?> getStoryById(String id) {
    return _firestoreService.getStoryById(id);
  }

  @override
  Future<void> markAsRead(String storyId) {
    return _firestoreService.markAsRead(storyId);
  }
}