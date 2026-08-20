import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/story_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String storiesCollection = 'stories';

  Stream<List<StoryModel>> watchStories() {
    return _db
        .collection(storiesCollection)
        .orderBy('fechaCreacion', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StoryModel.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  Future<StoryModel?> getStoryById(String id) async {
    final doc = await _db.collection(storiesCollection).doc(id).get();
    if (!doc.exists) return null;
    return StoryModel.fromFirestore(doc.id, doc.data()!);
  }

  Future<void> markAsRead(String storyId) async {
    await _db.collection(storiesCollection).doc(storyId).update({
      'leido': true,
    });
  }
}