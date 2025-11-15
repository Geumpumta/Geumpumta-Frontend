import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/dto/study/start_study_time_request_dto.dart';
import 'package:geumpumta/screens/home/widgets/custom_timer_widget.dart';
import 'package:geumpumta/screens/home/widgets/start_and_stop_btn.dart';
import 'package:geumpumta/screens/home/widgets/total_progress_dot.dart';
import 'package:geumpumta/viewmodel/study/study_viewmodel.dart';
import 'package:geumpumta/widgets/top_logo_bar/top_logo_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isTimerRunning = false;
  Duration _timerDuration = Duration.zero;
  Timer? _timer;

  void _startLocalTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _timerDuration += const Duration(seconds: 1);
      });
    });
  }

  void _stopLocalTimer() {
    _timer?.cancel();
  }

  Future<void> _refreshFromServer() async {
    final response = await ref.read(studyViewmodelProvider).getStudyTime();

    setState(() {
      _timerDuration = Duration(seconds: response!.data.totalStudySession);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(studyViewmodelProvider).getStudyTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    final studyViewModel = ref.watch(studyViewmodelProvider);

    return Scaffold(
      backgroundColor: const Color(0x1AFFFFFF),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 60,
            children: [
              SizedBox(height: 60),
              Column(
                children: [
                  CustomTimerWidget(duration: _timerDuration),
                  const SizedBox(height: 60),
                  TotalProgressDot(duration: _timerDuration),
                ],
              ),
              StartAndStopBtn(
                isTimerRunning: _isTimerRunning,
                onStart: () async {
                  DateTime now = DateTime.now();

                  final wifiData = await studyViewModel.getWIFIInfo();

                  final res = await studyViewModel.startStudyTime(
                    StartStudyTimeRequestDto(
                      startTime: now,
                      gatewayIp: wifiData['gatewayIp'] ?? '',
                      bssid: wifiData['bssid'] ?? '',
                    ),
                  );

                  if (res == null || !res.success) {
                    await Flushbar(
                      message: res?.message ?? "알 수 없는 오류",
                      backgroundColor: Colors.red.shade700,
                      flushbarPosition: FlushbarPosition.TOP,
                      margin: const EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(10),
                      duration: const Duration(seconds: 2),
                      icon: const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                      ),
                    ).show(context);
                    return;
                  }

                  setState(() {
                    _isTimerRunning = true;
                  });
                  _startLocalTimer();
                },


                onStop: () async {
                  setState(() {
                    _isTimerRunning = false;
                  });
                  _stopLocalTimer();
                  await _refreshFromServer();
                },
              ),
            ],
          ),

          const Positioned(top: 0, left: 0, right: 0, child: TopLogoBar()),
        ],
      ),
    );
  }
}
