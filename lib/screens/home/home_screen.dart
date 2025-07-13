import 'package:app_dopilot/screens/home/widgets/home_app_bar.dart';
import 'package:app_dopilot/screens/home/widgets/home_bottom_navigation_bar.dart';
import 'package:app_dopilot/screens/notifications/notifications_screen.dart';
import 'package:app_dopilot/screens/tasks/home_task_screen.dart';
import 'package:app_dopilot/widgets/app_floating_action_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomNavIndex = 0;

  final List<Widget> _screens = [
    HomeTaskScreen(),
    Container(),
    NotificationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onPressed: () {
                Navigator.of(context).pushNamed('/new-task');
              },
            ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });
  }
}
