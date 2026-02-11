import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_ball_run/providers/goal_provider.dart';
import 'package:speed_ball_run/services/firestore_service.dart';

void main() {
  group('GoalProvider', () {
    late FakeFirebaseFirestore fakeFirestore;
    late FirestoreService firestoreService;
    late GoalProvider goalProvider;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      firestoreService = FirestoreService(firestore: fakeFirestore);
      goalProvider = GoalProvider(firestoreService: firestoreService);
      goalProvider.setUser('test-user');
    });

    tearDown(() {
      goalProvider.dispose();
    });

    test('should remove a goal from the list', () async {
      await goalProvider.addGoal('Learn Flutter');
      await Future.delayed(Duration.zero);

      expect(goalProvider.goals.length, 1);

      final goalId = goalProvider.goals.first.id!;
      await goalProvider.removeGoal(goalId);
      await Future.delayed(Duration.zero);

      expect(goalProvider.goals.isEmpty, isTrue);
    });
  });
}
