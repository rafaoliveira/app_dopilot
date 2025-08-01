import 'package:app_dopilot/bloc/auth/auth_cubit.dart';
import 'package:app_dopilot/firebase_options.dart';
import 'package:app_dopilot/screen/auth/login_screen.dart';
import 'package:app_dopilot/screen/home/home_screen.dart';
import 'package:app_dopilot/screen/splash/splash_screen.dart';
import 'package:app_dopilot/screen/task/all_tasks_screen.dart';
import 'package:app_dopilot/screen/task/new_task_screen.dart';
import 'package:app_dopilot/service/auth_service.dart';
import 'package:app_dopilot/util/dio_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/task/daily_tasks_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicializar DioClient com AuthService
  final authService = AuthService();
  DioClient.initialize(authService);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => DailyTasksCubit()),
      ],
      child: MaterialApp(
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
          '/all-tasks': (context) => const AllTasksScreen(),
        },
      ),
    );
  }
}
