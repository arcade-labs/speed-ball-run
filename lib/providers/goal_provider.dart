
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/goal.dart';

class GoalProvider with ChangeNotifier {
  final List<Goal> _goals = [];
  Timer? _timer;

  List<Goal> get goals => _goals;

  GoalProvider() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      bool hasChanges = false;
      for (var goal in _goals) {
        if (goal.isRunning) {
          goal.duration += const Duration(seconds: 1);
          hasChanges = true;
        }
      }
      if (hasChanges) {
        notifyListeners();
      }
    });
  }

  void addGoal(String title) {
    _goals.add(Goal(
      title: title,
      creationDate: DateTime.now(),
    ));
    notifyListeners();
  }

  void removeGoal(int index) {
    _goals.removeAt(index);
    notifyListeners();
  }

  void toggleGoal(int index) {
    _goals[index].isCompleted = !_goals[index].isCompleted;
    notifyListeners();
  }

  void toggleTimer(int index) {
    _goals[index].toggleTimer();
    notifyListeners();
  }

  String formattedDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
