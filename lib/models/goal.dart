import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  String? id;
  String? userId;
  String title;
  DateTime creationDate;
  int accumulatedMs;
  DateTime? lastStartedAt;
  bool isRunning;
  bool isCompleted;

  Goal({
    this.id,
    this.userId,
    required this.title,
    required this.creationDate,
    this.accumulatedMs = 0,
    this.lastStartedAt,
    this.isRunning = false,
    this.isCompleted = false,
  });

  /// Current elapsed time including the active session (if running).
  Duration get elapsed {
    if (isRunning && lastStartedAt != null) {
      final activeMs = DateTime.now().difference(lastStartedAt!).inMilliseconds;
      return Duration(milliseconds: accumulatedMs + activeMs);
    }
    return Duration(milliseconds: accumulatedMs);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'creationDate': Timestamp.fromDate(creationDate),
      'accumulatedMs': accumulatedMs,
      'lastStartedAt': lastStartedAt != null
          ? Timestamp.fromDate(lastStartedAt!)
          : null,
      'isRunning': isRunning,
      'isCompleted': isCompleted,
      'userId': userId,
    };
  }

  factory Goal.fromMap(String id, Map<String, dynamic> map) {
    return Goal(
      id: id,
      userId: map['userId'] as String?,
      title: map['title'] as String,
      creationDate: (map['creationDate'] as Timestamp).toDate(),
      accumulatedMs: map['accumulatedMs'] as int? ?? 0,
      lastStartedAt: map['lastStartedAt'] != null
          ? (map['lastStartedAt'] as Timestamp).toDate()
          : null,
      isRunning: map['isRunning'] as bool? ?? false,
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }
}
