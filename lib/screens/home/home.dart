import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/dto/study/end_study_request_dto.dart';
import 'package:geumpumta/models/dto/study/send_heart_beat_request_dto.dart';
import 'package:geumpumta/models/dto/study/start_study_time_request_dto.dart';
import 'package:geumpumta/screens/home/widgets/custom_timer_widget.dart';
import 'package:geumpumta/screens/home/widgets/start_and_stop_btn.dart';
import 'package:geumpumta/screens/home/widgets/total_progress_dot.dart';
import 'package:geumpumta/viewmodel/study/study_viewmodel.dart';
import 'package:geumpumta/widgets/top_logo_bar/top_logo_bar.dart';

import '../../provider/userState/user_info_state.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isTimerRunning = false;
  Duration _timerDuration = Duration.zero;

  Timer? _timer;
  Timer? _heartBeatTimer;

  int _sessionId = 0;

  void _startLocalTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _timerDuration += const Duration(milliseconds: 1000);
      });
    });
  }

  void _stopLocalTimer() {
    _timer?.cancel();
  }

  void _startHeartBeat() {
    _heartBeatTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await _sendHeartBeat();
    });
  }

  void _stopHeartBeat() {
    _heartBeatTimer?.cancel();
  }

  Future<void> _sendHeartBeat() async {
    final vm = ref.read(studyViewmodelProvider);
    final wifi = await vm.getWIFIInfo();

    final res = await vm.sendHeartBeat(
      SendHeartBeatRequestDto(
        sessionId: _sessionId,
        gatewayIp: wifi['gatewayIp'] ?? '',
        clientIp: wifi['ip'] ?? '',
      ),
    );

    if (res == null || !res.success) {
      await Flushbar(
        message: res?.message ?? "하트비트 전송 실패: 세션 만료 가능성",
        backgroundColor: Colors.red.shade700,
        flushbarPosition: FlushbarPosition.TOP,
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  Future<void> _refreshFromServer() async {
    final response = await ref.read(studyViewmodelProvider).getStudyTime();
    if (response == null) return;

    final totalMillis = response.data.totalStudySession;

    setState(() {
      _timerDuration = Duration(milliseconds: totalMillis);
    });

    ref.read(userInfoStateProvider.notifier).updateTotalMillis(totalMillis);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshFromServer());
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(studyViewmodelProvider);

    return Scaffold(
      backgroundColor: const Color(0x1AFFFFFF),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 60,
            children: [
              const SizedBox(height: 60),
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
                  final now = DateTime.now();

                  final wifi = await vm.getWIFIInfo();

                  final res = await vm.startStudyTime(
                    StartStudyTimeRequestDto(
                      startTime: now,
                      gatewayIp: wifi['gatewayIp'] ?? '',
                      clientIp: wifi['ip'] ?? '',
                    ),
                  );

                  if (res == null || !res.success) {
                    await Flushbar(
                      message: res?.message ?? "시작 실패",
                      backgroundColor: Colors.red.shade700,
                      flushbarPosition: FlushbarPosition.TOP,
                      duration: const Duration(seconds: 2),
                    ).show(context);
                    return;
                  }

                  _sessionId = res.data.studySessionId;

                  setState(() => _isTimerRunning = true);
                  _startLocalTimer();

                  _startHeartBeat();
                },

                onStop: () async {
                  final res = await vm.endStudyTime(
                    EndStudyRequestDto(
                      studySessionId: _sessionId,
                      endTime: DateTime.now(),
                    ),
                  );

                  if (res == null || !res.success) {
                    await Flushbar(
                      message: res?.message ?? "종료 실패",
                      backgroundColor: Colors.red.shade700,
                      flushbarPosition: FlushbarPosition.TOP,
                    ).show(context);
                    return;
                  }

                  setState(() => _isTimerRunning = false);
                  _stopLocalTimer();
                  _stopHeartBeat();

                  await _refreshFromServer();
                  _sessionId = 0;
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
