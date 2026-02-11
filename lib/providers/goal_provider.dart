import 'dart:async';
import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/firestore_service.dart';

class GoalProvider with ChangeNotifier {
  final FirestoreService _firestoreService;
  String? _userId;
  List<Goal> _goals = [];
  Timer? _displayTimer;
  StreamSubscription? _goalsSub;

  List<Goal> get goals => _goals;

  GoalProvider({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  /// Test-only constructor: pre-populate goals without Firestore stream.
  @visibleForTesting
  GoalProvider.withGoals(List<Goal> goals,
      {FirestoreService? firestoreService, String? userId})
      : _firestoreService = firestoreService ?? FirestoreService(),
        _goals = goals,
        _userId = userId;

  void setUser(String? userId) {
    if (_userId == userId) return;
    _userId = userId;
    _goalsSub?.cancel();
    _goals = [];
    _stopDisplayTimer();

    if (userId != null) {
      _goalsSub = _firestoreService.goalsStream(userId).listen((goals) {
        _goals = goals;
        _updateDisplayTimer();
        notifyListeners();
      });
    } else {
      notifyListeners();
    }
  }

  /// Display timer: refreshes UI every second so running clocks tick.
  /// Does NOT write to Firestore -- purely visual.
  void _updateDisplayTimer() {
    final hasRunning = _goals.any((g) => g.isRunning);
    if (hasRunning && _displayTimer == null) {
      _displayTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => notifyListeners(),
      );
    } else if (!hasRunning && _displayTimer != null) {
      _stopDisplayTimer();
    }
  }

  void _stopDisplayTimer() {
    _displayTimer?.cancel();
    _displayTimer = null;
  }

  Future<void> addGoal(String title) async {
    if (_userId == null) return;
    final goal = Goal(
      title: title,
      creationDate: DateTime.now(),
      userId: _userId,
    );
    await _firestoreService.addGoal(_userId!, goal);
  }

  Future<void> removeGoal(String goalId) async {
    if (_userId == null) return;
    await _firestoreService.deleteGoal(_userId!, goalId);
  }

  Future<void> toggleGoal(String goalId) async {
    if (_userId == null) return;
    final goal = _goals.firstWhere((g) => g.id == goalId);
    final newState = !goal.isCompleted;

    // Stop the timer if completing a running goal
    if (newState && goal.isRunning) {
      final totalMs = goal.elapsed.inMilliseconds;
      goal.isRunning = false;
      goal.accumulatedMs = totalMs;
      goal.lastStartedAt = null;
      await _firestoreService.stopTimer(_userId!, goalId, totalMs);
      _updateDisplayTimer();
    }

    goal.isCompleted = newState;
    notifyListeners();
    await _firestoreService.toggleCompleted(_userId!, goalId, newState);
  }

  /// Start or stop the timer. Only 2 Firestore writes: one on start, one on stop.
  Future<void> toggleTimer(String goalId) async {
    if (_userId == null) return;
    final goal = _goals.firstWhere((g) => g.id == goalId);

    if (goal.isRunning) {
      // Stop: compute accumulated time, write once
      final totalMs = goal.elapsed.inMilliseconds;
      goal.isRunning = false;
      goal.accumulatedMs = totalMs;
      goal.lastStartedAt = null;
      _updateDisplayTimer();
      notifyListeners();
      await _firestoreService.stopTimer(_userId!, goalId, totalMs);
    } else {
      // Start: record timestamp, write once
      goal.isRunning = true;
      goal.lastStartedAt = DateTime.now();
      _updateDisplayTimer();
      notifyListeners();
      await _firestoreService.startTimer(_userId!, goalId);
    }
  }

  String formattedDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _stopDisplayTimer();
    _goalsSub?.cancel();
    super.dispose();
  }
}
