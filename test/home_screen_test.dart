import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/goal_provider.dart';
import 'package:myapp/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen should display a list of goals', (WidgetTester tester) async {
    // Arrange
    final goalProvider = GoalProvider();
    goalProvider.addGoal('Learn Flutter');
    goalProvider.addGoal('Build a Flutter App');

    // Act
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: goalProvider,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    // Assert
    expect(find.text('Learn Flutter'), findsOneWidget);
    expect(find.text('Build a Flutter App'), findsOneWidget);

    // Clean up
    goalProvider.dispose();
  });
}
