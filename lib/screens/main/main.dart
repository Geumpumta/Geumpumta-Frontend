import 'package:flutter/material.dart';
import 'package:geumpumta/screens/home/home.dart';

import '../ranking/ranking.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    // StatsScreen(),
    RankingScreen(),
    RankingScreen(),
    RankingScreen(),
    // MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isRankingPage = _selectedIndex == 2;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: isRankingPage
            ? const BoxDecoration(color: Colors.white)
            : BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
                color: Colors.white,
              ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled, size: 30),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart_rounded, size: 30),
              label: '통계',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_rounded, size: 30),
              label: '랭킹',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_rounded, size: 30),
              label: '전체',
            ),
          ],
        ),
      ),
    );
  }
}
