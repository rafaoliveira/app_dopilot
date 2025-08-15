import 'package:app_dopilot/bloc/auth/auth_cubit.dart';
import 'package:app_dopilot/bloc/notification/notification_cubit.dart';
import 'package:app_dopilot/bloc/task/all_task_cubit.dart';
import 'package:app_dopilot/bloc/task/new_task_cubit.dart';
import 'package:app_dopilot/bloc/task/daily_task_cubit.dart';
import 'package:app_dopilot/data/model/task.dart';
import 'package:app_dopilot/firebase_options.dart';
import 'package:app_dopilot/screen/auth/login_screen.dart';
import 'package:app_dopilot/screen/home/home_screen.dart';
import 'package:app_dopilot/screen/splash/splash_screen.dart';
import 'package:app_dopilot/screen/task/all_tasks_screen.dart';
import 'package:app_dopilot/screen/task/new_task_screen.dart';
import 'package:app_dopilot/service/auth_service.dart';
import 'package:app_dopilot/service/firebase_messaging_service.dart';
import 'package:app_dopilot/service/firebase_analytics_service.dart';
import 'package:app_dopilot/service/firebase_crashlytics_service.dart';
import 'package:app_dopilot/service/firebase_remote_config_service.dart';
import 'package:app_dopilot/util/dio_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicializar Firebase Crashlytics
  final firebaseCrashlyticsService = FirebaseCrashlyticsService();
  await firebaseCrashlyticsService.initialize();

  // Inicializar Firebase Remote Config
  final firebaseRemoteConfigService = FirebaseRemoteConfigService();
  await firebaseRemoteConfigService.initialize();

  // Inicializar Firebase Service (FCM)
  final firebaseMessagingService = FirebaseMessagingService();
  await firebaseMessagingService.initialize();

  // Inicializar DioClient com AuthService
  final authService = AuthService();
  DioClient.initialize(authService, firebaseRemoteConfigService);

  runApp(MyApp(firebaseMessagingService: firebaseMessagingService,));
}

class MyApp extends StatelessWidget {

  final FirebaseMessagingService firebaseMessagingService;

  const MyApp({super.key, required this.firebaseMessagingService});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Criar instância do Analytics para o observer
    final firebaseAnalyticsService = FirebaseAnalyticsService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(firebaseMessagingService)),
        BlocProvider(create: (context) => DailyTaskCubit()),
        BlocProvider(create: (context) => AllTaskCubit()),
        BlocProvider(create: (context) => NewTaskCubit()),
        BlocProvider(create: (context) => NotificationCubit()),
      ],
      child: MaterialApp(
        title: 'DoPilot',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7B2CBF)),
          useMaterial3: true,
        ),
        navigatorObservers: [
          firebaseAnalyticsService.observer,
        ],
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/all-tasks': (context) => const AllTasksScreen(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/new-task':
              var arguments = settings.arguments as Map<String, dynamic>?;
              final task = arguments?['task'] as Task?;
              return MaterialPageRoute(
                builder: (context) => NewTaskScreen(task: task),
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}
