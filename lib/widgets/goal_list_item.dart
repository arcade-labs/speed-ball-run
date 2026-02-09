
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import '../providers/goal_provider.dart';

class GoalListItem extends StatelessWidget {
  final Goal goal;
  final int index;

  const GoalListItem({super.key, required this.goal, required this.index});

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);

    return ListTile(
      title: Text(goal.title, style: GoogleFonts.lato(fontSize: 18)),
      subtitle: Text(
        'Created: ${DateFormat.yMd().add_jm().format(goal.creationDate)}',
        style: GoogleFonts.lato(),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            goalProvider.formattedDuration(goal.duration),
            style: GoogleFonts.lato(fontSize: 16),
          ),
          IconButton(
            icon: Icon(goal.isRunning ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              goalProvider.toggleTimer(index);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              goalProvider.removeGoal(index);
            },
          ),
        ],
      ),
    );
  }
}
