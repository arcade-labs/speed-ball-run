import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/providers/goal_provider.dart';

void main() {
  group('GoalProvider', () {
    test('should toggle the completion status of a goal', () {
      // Arrange
      final goalProvider = GoalProvider();
      const goalTitle = 'Learn Flutter';
      goalProvider.addGoal(goalTitle);

      // Act
      goalProvider.toggleGoal(0);

      // Assert
      expect(goalProvider.goals.first.isCompleted, isTrue);

      // Act
      goalProvider.toggleGoal(0);

      // Assert
      expect(goalProvider.goals.first.isCompleted, isFalse);
    });
  });
}
