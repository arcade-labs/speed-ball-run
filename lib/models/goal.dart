class Goal {
  String title;
  DateTime creationDate;
  Duration duration;
  bool isRunning;
  bool isCompleted;

  Goal({
    required this.title,
    required this.creationDate,
    this.duration = Duration.zero,
    this.isRunning = false,
    this.isCompleted = false,
  });

  void toggleTimer() {
    isRunning = !isRunning;
  }
}
