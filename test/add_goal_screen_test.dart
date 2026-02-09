import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/goal_provider.dart';
import 'package:myapp/screens/add_goal_screen.dart';

void main() {
  testWidgets('AddGoalScreen should add a new goal', (WidgetTester tester) async {
    // Arrange
    final goalProvider = GoalProvider();

    // Act
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: goalProvider,
        child: const MaterialApp(home: AddGoalScreen()),
      ),
    );

    // Enter a goal title
    await tester.enterText(find.byType(TextField), 'New Goal');

    // Tap the add button
    await tester.tap(find.byType(ElevatedButton));

    // Rebuild the widget
    await tester.pump();

    // Assert
    expect(goalProvider.goals.length, 1);
    expect(goalProvider.goals.first.title, 'New Goal');

    // Clean up
    goalProvider.dispose();
  });
}
