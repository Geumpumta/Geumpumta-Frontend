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
import 'package:geumpumta/widgets/error_dialog/error_dialog.dart';
import 'package:geumpumta/widgets/loading_dialog/loading_dialog.dart';

import '../../provider/study/study_provider.dart';
import '../../provider/userState/user_info_state.dart';
import '../../main.dart';
import '../../widgets/top_logo_bar/top_logo_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with RouteAware {
  bool _isTimerRunning = false;

  Duration _timerDuration = Duration.zero;
  Duration _accumulatedDuration = Duration.zero;
  DateTime? _sessionStartTime;

  Timer? _timer;
  Timer? _heartBeatTimer;
  int _sessionId = 0;

  late final AppLifecycleListener _appLifecycleListener;

  @override
  void initState() {
    super.initState();

    final totalMillis = ref.read(userInfoStateProvider)?.totalMillis ?? 0;

    _timerDuration = Duration(milliseconds: totalMillis);

    _appLifecycleListener = AppLifecycleListener(
      onStateChange: _onLifecycleChanged,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshFromServer();
    });
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _timer?.cancel();
    _heartBeatTimer?.cancel();
    _appLifecycleListener.dispose();
    super.dispose();
  }

  Future<void> _onLifecycleChanged(AppLifecycleState state) async {
    print("Lifecycle: $state");

    if (!_isTimerRunning) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _updateTimerUI();
        break;

      case AppLifecycleState.hidden:
        print("화면 OFF 감지 → 타이머 유지");
        break;

      case AppLifecycleState.inactive:
        print("inactive 상태 → 유지");
        break;

      case AppLifecycleState.paused:
        print("PAUSED 감지 (앱 이탈) → 공부 종료");
        await _endStudyInternal(showDialog: true);
        break;

      case AppLifecycleState.detached:
        print("DETACHED → 앱 종료 감지");
        await _endStudyInternal(showDialog: false);
        break;
    }
  }

  @override
  void didPushNext() async {
    if (_isTimerRunning) {
      await _endStudyInternal(showDialog: true);
    }
  }

  Future<void> _endStudyInternal({bool showDialog = false}) async {
    _stopLocalTimer();
    _stopHeartBeat();

    _isTimerRunning = false;
    _sessionStartTime = null;
    _accumulatedDuration = Duration.zero;

    ref.read(studyRunningProvider.notifier).state = false;

    final vm = ref.read(studyViewmodelProvider);

    await vm.endStudyTime(
      EndStudyRequestDto(studySessionId: _sessionId, endTime: DateTime.now()),
    );

    _sessionId = 0;
    await _refreshFromServer();

    if (showDialog && mounted) {
      ErrorDialog.show(context, "공부가 종료되었어요!");
    }
  }

  void _startLocalTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimerUI();
    });
  }

  void _updateTimerUI() {
    if (_sessionStartTime == null) return;

    setState(() {
      final now = DateTime.now();
      _timerDuration =
          _accumulatedDuration + now.difference(_sessionStartTime!);
    });
  }

  void _stopLocalTimer() {
    _timer?.cancel();
  }

  void _startHeartBeat() {
    _heartBeatTimer?.cancel();
    _heartBeatTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
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
      ErrorDialog.show(context, res?.data.message ?? "하트비트 전송 실패");
      await _endStudyInternal(showDialog: false);
    }
  }

  Future<void> _refreshFromServer() async {
    final response = await ref.read(studyViewmodelProvider).getStudyTime();
    if (response == null) return;

    final totalMillis = response.data.totalStudySession;

    setState(() {
      if (!_isTimerRunning) {
        _timerDuration = Duration(milliseconds: totalMillis);
      }
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
      child: Container(
        color: const Color(0x1AFFFFFF),
        child: Stack(
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
                        ErrorDialog.show(context, "교내 WIFI로 연결되어야 합니다.");
                        return;
                      }

                      _sessionId = res.data?.studySessionId ?? -1;

                      setState(() {
                        _isTimerRunning = true;
                        _sessionStartTime = DateTime.now();
                        _accumulatedDuration = _timerDuration;
                      });

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
                      await _endStudyInternal();
                      LoadingDialog.hide(context);
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
