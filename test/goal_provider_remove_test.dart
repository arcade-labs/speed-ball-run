import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/models/goal.dart';
import 'package:myapp/providers/goal_provider.dart';

void main() {
  group('GoalProvider', () {
    test('should remove a goal from the list', () {
      // Arrange
      final goalProvider = GoalProvider();
      const goalTitle = 'Learn Flutter';
      goalProvider.addGoal(goalTitle);

      // Act
      goalProvider.removeGoal(0);

      // Assert
      expect(goalProvider.goals.isEmpty, isTrue);
    });
  });
}
