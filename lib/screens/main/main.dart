import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/screens/home/home.dart';
import 'package:geumpumta/viewmodel/badge/unnotified_badge_check_viewmodel.dart';
import 'package:geumpumta/widgets/badge/unnotified_badge_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/study/study_provider.dart';
import '../../viewmodel/stats/grass_stats_viewmodel.dart';
import '../../widgets/error_dialog/error_dialog.dart';
import '../../widgets/bottom_ad_banner/bottom_ad_banner.dart';
import '../more/more.dart';
import '../ranking/ranking.dart';
import '../stats/stats.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, this.checkUnnotifiedBadgesOnEnter = false});

  final bool checkUnnotifiedBadgesOnEnter;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;
  bool _showAdBanner = true;
  bool _didCheckUnnotifiedOnEnter = false;

  final List<Widget> _pages = const [
    HomeScreen(),
    StatsScreen(),
    RankingScreen(),
    MoreScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // 앱 시작 시 광고 배너 표시 여부를 확인하는 콜백
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowAdBanner();
      _checkUnnotifiedBadgesOnEnterIfNeeded();
    });
  }

  Future<void> _checkUnnotifiedBadgesOnEnterIfNeeded() async {
    if (_didCheckUnnotifiedOnEnter) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final todayKey = _localDateKey(DateTime.now());
    final lastCheckedDate =
        prefs.getString('lastUnnotifiedBadgeCheckDate');
    final isFirstLaunchToday = lastCheckedDate != todayKey;
    final shouldCheck =
        widget.checkUnnotifiedBadgesOnEnter || isFirstLaunchToday;

    if (!shouldCheck) return;
    _didCheckUnnotifiedOnEnter = true;
    debugPrint(
      'UnnotifiedBadgeCheck: today=$todayKey last=$lastCheckedDate '
      'firstLaunchToday=$isFirstLaunchToday forced=${widget.checkUnnotifiedBadgesOnEnter}',
    );

    final badges = await ref
        .read(unnotifiedBadgeCheckViewModelProvider.notifier)
        .checkUnnotifiedBadges();

    await prefs.setString('lastUnnotifiedBadgeCheckDate', todayKey);
    debugPrint('UnnotifiedBadgeCheck: saved lastUnnotifiedBadgeCheckDate=$todayKey');
    if (!mounted || badges.isEmpty) return;
    await UnnotifiedBadgeModal.showSequence(context, badges);
  }

  Future<void> _checkAndShowAdBanner() async {
    final prefs = await SharedPreferences.getInstance();
    final hideAdBanner = prefs.getBool('hideAdBanner') ?? false;

    if (mounted) {
      setState(() {
        _showAdBanner = !hideAdBanner;
      });
    }
  }

  void _onItemTapped(int index) {
    final isRunning = ref.read(studyRunningProvider);

    if (isRunning && index != 0) {
      ErrorDialog.show(context, "공부 중에는 이동할 수 없어요!");
      return;
    }

    // 통계 탭으로 이동할 때마다 연속공부현황 provider 새로고침
    if (index == 1) {
      final _ = ref.refresh(currentStreakProvider(null));
    }

    setState(() => _selectedIndex = index);
  }

  String _localDateKey(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Widget _buildBottomNavBar() {
    final bool isRankingPage = _selectedIndex == 2;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: _pages[_selectedIndex]),
              _buildBottomNavBar(),
            ],
          ),
          if (_showAdBanner)
            BottomAdBanner(
              onClosed: () {
                setState(() {
                  _showAdBanner = false;
                });
              },
            ),
        ],
      ),
    );
  }
}
