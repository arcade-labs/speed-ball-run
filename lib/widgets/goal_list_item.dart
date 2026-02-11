import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import '../providers/goal_provider.dart';

class GoalListItem extends StatelessWidget {
  final Goal goal;

  const GoalListItem({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);
    final goalId = goal.id;
    if (goalId == null) return const SizedBox.shrink();

    final isCompleted = goal.isCompleted;
    final isRunning = goal.isRunning;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFF00E676).withValues(alpha: 0.08)
                  : isRunning
                      ? const Color(0xFFD97736).withValues(alpha: 0.08)
                      : Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isCompleted
                    ? const Color(0xFF00E676).withValues(alpha: 0.2)
                    : isRunning
                        ? const Color(0xFFD97736).withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.05),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Opacity(
              opacity: isCompleted ? 0.75 : 1.0,
              child: Row(
                children: [
                  // Completion toggle
                  GestureDetector(
                    onTap: () => goalProvider.toggleGoal(goalId),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted
                              ? const Color(0x0000E676).withValues(
                                  red: 0, green: 0.9, blue: 0.46, alpha: 1)
                              : Colors.white.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        color: isCompleted
                            ? const Color(0xFF00E676).withValues(alpha: 0.2)
                            : Colors.transparent,
                      ),
                      child: isCompleted
                          ? const Center(
                              child: Icon(Icons.check,
                                  size: 14, color: Color(0xFF00E676)),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title + date tag
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            decoration:
                                isCompleted ? TextDecoration.lineThrough : null,
                            decorationColor: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            DateFormat('MMM d, h:mm a')
                                .format(goal.creationDate),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.4),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Timer display
                  Text(
                    goalProvider.formattedDuration(goal.elapsed),
                    style: const TextStyle(
                      fontFamily: 'SF Mono',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Play/Pause button (hidden when completed)
                  if (!isCompleted) ...[
                    GestureDetector(
                      onTap: () => goalProvider.toggleTimer(goalId),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isRunning
                              ? const Color(0xFFD97736).withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.08),
                          border: isRunning
                              ? Border.all(
                                  color: const Color(0xFFD97736)
                                      .withValues(alpha: 0.3))
                              : null,
                        ),
                        child: Icon(
                          isRunning ? Icons.pause : Icons.play_arrow,
                          size: 16,
                          color: isRunning
                              ? const Color(0xFFD97736)
                              : Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],

                  // Delete button
                  GestureDetector(
                    onTap: () => goalProvider.removeGoal(goalId),
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
