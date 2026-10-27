import 'package:flutter/material.dart';
import '../shared/widgets/app_bottom_nav.dart';
import 'home/presentation/home_screen.dart';
import 'learning/presentation/learning_screen.dart';
import 'sql_game/presentation/sql_game_screen.dart';
import 'profile/presentation/profile_screen.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(onNavigateTab: _onTabSelected),
          const LearningScreen(),
          const SqlGameScreen(),
          ProfileScreen(onNavigateTab: _onTabSelected),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}
