import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:speed_ball_run/models/goal.dart';
import 'package:speed_ball_run/providers/auth_provider.dart' show AuthProvider;
import 'package:speed_ball_run/providers/goal_provider.dart';
import 'package:speed_ball_run/screens/home_screen.dart';
import 'package:speed_ball_run/services/firestore_service.dart';

import 'helpers/mock_auth_provider.dart';

void main() {
  late FirestoreService firestoreService;

  setUp(() {
    firestoreService = FirestoreService(firestore: FakeFirebaseFirestore());
  });

  testWidgets('HomeScreen should display a list of goals',
      (WidgetTester tester) async {
    final goalProvider = GoalProvider.withGoals(
      [
        Goal(
          id: '1',
          title: 'Learn Flutter',
          creationDate: DateTime(2025, 1, 1),
        ),
        Goal(
          id: '2',
          title: 'Build a Flutter App',
          creationDate: DateTime(2025, 1, 2),
        ),
      ],
      firestoreService: firestoreService,
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(
            value: MockAuthProvider(),
          ),
          ChangeNotifierProvider<GoalProvider>.value(
            value: goalProvider,
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.text('Learn Flutter'), findsOneWidget);
    expect(find.text('Build a Flutter App'), findsOneWidget);
  });

  testWidgets('HomeScreen should show empty state when no goals',
      (WidgetTester tester) async {
    final goalProvider = GoalProvider.withGoals(
      [],
      firestoreService: firestoreService,
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(
            value: MockAuthProvider(),
          ),
          ChangeNotifierProvider<GoalProvider>.value(
            value: goalProvider,
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.text('No goals yet'), findsOneWidget);
  });
}
