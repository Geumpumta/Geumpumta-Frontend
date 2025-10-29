import 'package:flutter/material.dart';
import 'package:geumpumta/screens/home/widgets/custom_timer_widget.dart';
import 'package:geumpumta/screens/home/widgets/start_and_stop_btn.dart';
import 'package:geumpumta/screens/home/widgets/total_progress_dot.dart';
import 'package:geumpumta/widgets/top_logo_bar/top_logo_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isTimerRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x1AFFFFFF),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 60,
            children: [
              SizedBox(height: 60),
              Center(
                child: CustomTimerWidget(
                  duration: const Duration(hours: 16, minutes: 18, seconds: 34),
                ),
              ),
              SizedBox(height: 10),
              TotalProgressDot(
                duration: const Duration(hours: 16, minutes: 18, seconds: 34),
              ),
              StartAndStopBtn(isTimerRunning: _isTimerRunning, onStart: () =>
                  setState(() {
                    _isTimerRunning = true;
                  }), onStop: () =>
                  setState(() {
                    _isTimerRunning = false;
                  }),),
            ],
          ),

          const Positioned(top: 0, left: 0, right: 0, child: TopLogoBar()),
        ],
      ),
    );
  }
}
