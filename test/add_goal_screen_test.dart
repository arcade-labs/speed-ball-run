import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:speed_ball_run/providers/goal_provider.dart';
import 'package:speed_ball_run/screens/add_goal_screen.dart';
import 'package:speed_ball_run/services/firestore_service.dart';

void main() {
  testWidgets('AddGoalScreen should add a new goal',
      (WidgetTester tester) async {
    final fakeFirestore = FakeFirebaseFirestore();
    final firestoreService = FirestoreService(firestore: fakeFirestore);

    // Use withGoals + userId so addGoal works without a stream subscription.
    final goalProvider = GoalProvider.withGoals(
      [],
      firestoreService: firestoreService,
      userId: 'test-user',
    );

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: Text('Home')),
          routes: [
            GoRoute(
              path: 'add',
              builder: (_, __) => const AddGoalScreen(),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<GoalProvider>.value(
        value: goalProvider,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    // Navigate to the add screen
    router.push('/add');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.enterText(find.byType(TextField), 'New Goal');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify the goal was written to Firestore
    final snapshot =
        await fakeFirestore.collection('users/test-user/goals').get();
    expect(snapshot.docs.length, 1);
    expect(snapshot.docs.first.data()['title'], 'New Goal');
  });
}
