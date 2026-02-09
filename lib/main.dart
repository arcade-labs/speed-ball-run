
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './providers/goal_provider.dart';
import './screens/home_screen.dart';
import './screens/add_goal_screen.dart';

void main() {
  runApp(const GoalListApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const AddGoalScreen(),
    ),
  ],
);

class GoalListApp extends StatelessWidget {
  const GoalListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoalProvider(),
      child: MaterialApp.router(
        title: 'Goal List App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[50],
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            titleTextStyle: GoogleFonts.lato(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}
