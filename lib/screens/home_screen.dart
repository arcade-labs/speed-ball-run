import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/goal_provider.dart';
import '../widgets/goal_list_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icon/app_icon_foreground.png',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Goals',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => authProvider.signOut(),
                      child: Icon(
                        Icons.logout_rounded,
                        size: 20,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),

              // Goal list
              Expanded(
                child: goalProvider.goals.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_fire_department_outlined,
                                size: 48,
                                color: Colors.white.withValues(alpha: 0.15)),
                            const SizedBox(height: 12),
                            Text(
                              'No goals yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap + to start tracking',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 100),
                        itemCount: goalProvider.goals.length,
                        itemBuilder: (context, index) {
                          final goal = goalProvider.goals[index];
                          return GoalListItem(goal: goal);
                        },
                      ),
              ),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
