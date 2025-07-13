import 'package:app_dopilot/screens/auth/login_screen.dart';
import 'package:app_dopilot/screens/home/home_screen.dart';
import 'package:app_dopilot/screens/splash/splash_screen.dart';
import 'package:app_dopilot/screens/tasks/new_task_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoPilot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7B2CBF)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/new-task': (context) => const NewTaskScreen(),
      },
    );
  }
}
