import '../entities/story.dart';

abstract class StoryRepository {
  Stream<List<Story>> watchStories();
  Future<Story?> getStoryById(String id);
  Future<void> markAsRead(String storyId);
}