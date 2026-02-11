import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_ball_run/providers/goal_provider.dart';
import 'package:speed_ball_run/services/firestore_service.dart';

void main() {
  group('GoalProvider', () {
    late FakeFirebaseFirestore fakeFirestore;
    late GoalProvider goalProvider;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      final firestoreService = FirestoreService(firestore: fakeFirestore);
      goalProvider = GoalProvider(firestoreService: firestoreService);
      goalProvider.setUser('test-user');
    });

    tearDown(() {
      goalProvider.dispose();
    });

    test('should add a goal to the list', () async {
      await goalProvider.addGoal('Learn Flutter');
      await Future.delayed(Duration.zero);

      expect(goalProvider.goals.length, 1);
      expect(goalProvider.goals.first.title, 'Learn Flutter');
      expect(goalProvider.goals.first.isCompleted, isFalse);
    });
  });
}
