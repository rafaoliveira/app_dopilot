import 'package:app_dopilot/bloc/auth/auth_cubit.dart';
import 'package:app_dopilot/bloc/auth/auth_state.dart';
import 'package:app_dopilot/screen/home/widget/home_app_bar.dart';
import 'package:app_dopilot/screen/home/widget/home_bottom_navigation_bar.dart';
import 'package:app_dopilot/screen/notification/notifications_screen.dart';
import 'package:app_dopilot/screen/statistic/statistics_screen.dart';
import 'package:app_dopilot/screen/task/home_task_screen.dart';
import 'package:app_dopilot/widget/app_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomNavIndex = 0;
  late HomeTaskController homeTaskController;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeTaskScreen(
        onSeeAllCallback: (controller) {
          homeTaskController = controller;
        },
      ),
      StatisticsScreen(),
      NotificationsScreen(),
    ];
  }

  //if (state is AuthUnauthenticated) {
  //Navigator.pushReplacementNamed(context, '/login');
  //}
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: HomeAppBar(),
        body: SafeArea(child: _screens[_currentBottomNavIndex]),
        bottomNavigationBar: HomeBottomNavigationBar(
          currentIndex: _currentBottomNavIndex,
          onTap: _onBottomNavTap,
        ),
        floatingActionButton: _currentBottomNavIndex != 0
            ? null
            : AppFloatingActionButton(
                onPressed: () async {
                  await Navigator.of(context).pushNamed('/new-task');
                  homeTaskController.refreshTasks();
                },
              ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });
  }
}
