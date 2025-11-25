import 'dart:async';

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
import 'package:geumpumta/widgets/error_dialog/error_dialog.dart';
import 'package:geumpumta/widgets/loading_dialog/loading_dialog.dart';

import '../../provider/study/study_provider.dart';
import '../../provider/userState/user_info_state.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {

  bool _isTimerRunning = false;
  Duration _timerDuration = Duration.zero;

  Timer? _timer;
  Timer? _heartBeatTimer;

  int _sessionId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshFromServer());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _heartBeatTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!_isTimerRunning) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {

      _stopLocalTimer();
      _stopHeartBeat();
      _isTimerRunning = false;

      ref.read(studyRunningProvider.notifier).state = false;

      ErrorDialog.show(
        context,
        "앱을 벗어나 공부가 종료되었어요!",
      );

      final vm = ref.read(studyViewmodelProvider);
      await vm.endStudyTime(
        EndStudyRequestDto(
          studySessionId: _sessionId,
          endTime: DateTime.now(),
        ),
      );

      _sessionId = 0;
      await _refreshFromServer();
    }
  }


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
      ErrorDialog.show(
        context,
        res?.message ?? "하트비트 전송에 실패했어요.",
      );
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
  Widget build(BuildContext context) {
    final vm = ref.watch(studyViewmodelProvider);

    return WillPopScope(
      onWillPop: () async {
        if (_isTimerRunning) {
          ErrorDialog.show(context, "공부 중에는 이동할 수 없어요!");
          return false;
        }
        return true;
      },
      child: Scaffold(
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
                    LoadingDialog.show(context);

                    try {
                      final now = DateTime.now();
                      final wifi = await vm.getWIFIInfo();

                      final res = await vm.startStudyTime(
                        StartStudyTimeRequestDto(
                          startTime: now,
                          gatewayIp: wifi['gatewayIp'] ?? '',
                          clientIp: wifi['ip'] ?? '',
                        ),
                      );

                      LoadingDialog.hide(context);

                      if (res == null || !res.success) {
                        ErrorDialog.show(context, res?.message ?? "시작 실패");
                        return;
                      }

                      _sessionId = res.data?.studySessionId ?? -1;

                      setState(() => _isTimerRunning = true);
                      ref.read(studyRunningProvider.notifier).state = true;

                      _startLocalTimer();
                      _startHeartBeat();

                    } catch (e) {
                      LoadingDialog.hide(context);
                      ErrorDialog.show(context, "시작 실패: $e");
                    }
                  },

                  onStop: () async {
                    LoadingDialog.show(context);

                    try {
                      final res = await vm.endStudyTime(
                        EndStudyRequestDto(
                          studySessionId: _sessionId,
                          endTime: DateTime.now(),
                        ),
                      );

                      LoadingDialog.hide(context);

                      if (res == null || !res.success) {
                        ErrorDialog.show(context, res?.message ?? "종료 실패");
                        return;
                      }

                      setState(() => _isTimerRunning = false);
                      ref.read(studyRunningProvider.notifier).state = false;

                      _stopLocalTimer();
                      _stopHeartBeat();
                      _sessionId = 0;

                      await _refreshFromServer();

                    } catch (e) {
                      LoadingDialog.hide(context);
                      ErrorDialog.show(context, "종료 실패: $e");
                    }
                  },
                ),
              ],
            ),
            const Positioned(top: 0, left: 0, right: 0, child: TopLogoBar()),
          ],
        ),
      ),
    );
  }
}
