import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _goalsCollection(String userId) {
    return _db.collection('users').doc(userId).collection('goals');
  }

  Stream<List<Goal>> goalsStream(String userId) {
    return _goalsCollection(userId)
        .orderBy('creationDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Goal.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<String> addGoal(String userId, Goal goal) async {
    goal.userId = userId;
    final docRef = await _goalsCollection(userId).add(goal.toMap());
    return docRef.id;
  }

  /// Start timer: record the current time as lastStartedAt.
  Future<void> startTimer(String userId, String goalId) async {
    await _goalsCollection(userId).doc(goalId).update({
      'isRunning': true,
      'lastStartedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  /// Stop timer: accumulate elapsed time, clear lastStartedAt.
  Future<void> stopTimer(
      String userId, String goalId, int newAccumulatedMs) async {
    await _goalsCollection(userId).doc(goalId).update({
      'isRunning': false,
      'accumulatedMs': newAccumulatedMs,
      'lastStartedAt': null,
    });
  }

  Future<void> toggleCompleted(
      String userId, String goalId, bool isCompleted) async {
    await _goalsCollection(userId).doc(goalId).update({
      'isCompleted': isCompleted,
    });
  }

  Future<void> deleteGoal(String userId, String goalId) async {
    await _goalsCollection(userId).doc(goalId).delete();
  }
}
