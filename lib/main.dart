import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './providers/auth_provider.dart';
import './providers/goal_provider.dart';
import './screens/add_goal_screen.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const GoalListApp());
}

class GoalListApp extends StatelessWidget {
  const GoalListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, GoalProvider>(
          create: (_) => GoalProvider(),
          update: (_, auth, goalProvider) {
            goalProvider!.setUser(auth.userId);
            return goalProvider;
          },
        ),
      ],
      child: const _AppRouter(),
    );
  }
}

class _AppRouter extends StatelessWidget {
  const _AppRouter();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final router = GoRouter(
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final isOnLogin = state.matchedLocation == '/login';

        if (!isAuthenticated && !isOnLogin) return '/login';
        if (isAuthenticated && isOnLogin) return '/';
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/add',
          builder: (context, state) => const AddGoalScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
      ],
    );

    const bgColor = Color(0xFF050505);
    const surfaceColor = Color(0xFF1E1E1E);
    const accentOrange = Color(0xFFD97736);
    const textSecondary = Color(0xFFA0A0A0);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1E1E),
            Color(0xFF050505),
          ],
        ),
      ),
      child: MaterialApp.router(
      title: 'Speed Ball Run',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: const ColorScheme.dark(
          surface: surfaceColor,
          primary: accentOrange,
          secondary: accentOrange,
          error: Color(0xFFC93B3B),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.latoTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          color: surfaceColor.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
          ),
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: accentOrange,
          foregroundColor: Colors.white,
          shape: CircleBorder(),
        ),
        iconTheme: const IconThemeData(color: textSecondary),
        dividerColor: Colors.white.withValues(alpha: 0.05),
      ),
      themeMode: ThemeMode.dark,
      routerConfig: router,
      ),
    );
  }
}
