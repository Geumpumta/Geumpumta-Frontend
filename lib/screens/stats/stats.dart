import 'package:flutter/material.dart';
import 'package:geumpumta/screens/stats/widgets/daily_stats_view.dart';
import 'package:geumpumta/screens/stats/widgets/weekly_stats_view.dart';
import 'package:geumpumta/screens/stats/widgets/monthly_stats_view.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0BAEFF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '통계',
          style: TextStyle(
            color: Color(0xFF0BAEFF),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF0BAEFF),
            indicatorWeight: 2,
            labelColor: const Color(0xFF0BAEFF),
            unselectedLabelColor: const Color(0xFF999999),
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            tabs: const [
              Tab(text: '일간'),
              Tab(text: '주간'),
              Tab(text: '월간'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DailyStatsView(),
          WeeklyStatsView(),
          MonthlyStatsView(),
        ],
      ),
    );
  }
}

