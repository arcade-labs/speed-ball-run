
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/goal_provider.dart';
import '../widgets/goal_list_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Goals', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        itemCount: goalProvider.goals.length,
        itemBuilder: (context, index) {
          return GoalListItem(goal: goalProvider.goals[index], index: index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
