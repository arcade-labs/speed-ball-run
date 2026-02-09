import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/providers/goal_provider.dart';

void main() {
  group('GoalProvider', () {
    test('should add a goal to the list', () {
      // Arrange
      final goalProvider = GoalProvider();
      const goalTitle = 'Learn Flutter';

      // Act
      goalProvider.addGoal(goalTitle);

      // Assert
      expect(goalProvider.goals.length, 1);
      expect(goalProvider.goals.first.title, goalTitle);
      expect(goalProvider.goals.first.isCompleted, isFalse);
    });
  });
}
