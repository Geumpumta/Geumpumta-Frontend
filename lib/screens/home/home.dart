import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/models/dto/study/end_study_request_dto.dart';
import 'package:geumpumta/models/dto/study/send_heart_beat_request_dto.dart';
import 'package:geumpumta/models/dto/study/start_study_time_request_dto.dart';
import 'package:geumpumta/screens/home/widgets/custom_timer_widget.dart';
import 'package:geumpumta/screens/home/widgets/set_block_app_icon.dart';
import 'package:geumpumta/screens/home/widgets/start_and_stop_btn.dart';
import 'package:geumpumta/screens/home/widgets/total_progress_dot.dart';
import 'package:geumpumta/screens/onboarding/onboarding_page.dart';
import 'package:geumpumta/viewmodel/study/study_viewmodel.dart';
import 'package:geumpumta/widgets/error_dialog/error_dialog.dart';
import 'package:geumpumta/widgets/loading_dialog/loading_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../provider/study/study_provider.dart';
import '../../provider/userState/user_info_state.dart';
import '../../util/focus_setup_store.dart';
import '../../util/ios_channels.dart';
import '../../widgets/top_logo_bar/top_logo_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  static const MethodChannel platform = MethodChannel("network_monitor");

  bool _isTimerRunning = false;

  Duration _timerDuration = Duration.zero;
  Duration _accumulatedDuration = Duration.zero;

  DateTime? _sessionStartTime;

  Timer? _timer;
  Timer? _heartBeatTimer;
  int _sessionId = 0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isTimerRunning) return;
    if (Theme.of(context).platform != TargetPlatform.iOS) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      IosFocusControl.stopFocus();
    }
  }

  void _setupNetworkListener() {
    platform.setMethodCallHandler((call) async {
      if (!_isTimerRunning) return;

      if (call.method == "network_changed") {
        final data = Map<String, dynamic>.from(call.arguments ?? {});

        if (data["type"] == "lost" || data["isWifi"] == false) {
          print("네트워크 변경 감지 → 공부 종료");
          ErrorDialog.show(context, "네트워크 변경이 감지되어\n공부가 종료되었어요!");
          await _endStudyInternal();
        }
      }
    });
  }

  Future<void> _requestLocationPermission() async {
    await Permission.locationWhenInUse.request();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _maybeShowFocusOnboarding();

    _requestLocationPermission();
    _setupNetworkListener();

    final totalMillis = ref.read(userInfoStateProvider)?.totalMillis ?? 0;
    _timerDuration = Duration(milliseconds: totalMillis);

    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshFromServer());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosFocusControl.stopFocus();
    }
    _timer?.cancel();
    _heartBeatTimer?.cancel();
    super.dispose();
  }

  Future<void> _maybeShowFocusOnboarding() async {
    final done = await FocusSetupStore.isDone();
    if (done) return;
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingPage()),
    );
  }

  Future<void> _endStudyInternal() async {
    print("endStudyInternal 호출됨");

    final vm = ref.read(studyViewmodelProvider);

    try {
      final res = await vm.endStudyTime(
        EndStudyRequestDto(studySessionId: _sessionId),
      );

      if (res == null || !res.success) {
        print("endStudyTime 실패");
        if (!mounted) return;
        ErrorDialog.show(context, "공부 종료에 실패했습니다.");
        return;
      }

      if (Theme.of(context).platform == TargetPlatform.iOS) {
        try {
          await IosFocusControl.stopFocus();
        } catch (_) {}
      }

      _stopLocalTimer();
      _stopHeartBeat();

      if (!mounted) return;
      setState(() {
        _isTimerRunning = false;
        _sessionStartTime = null;
        _accumulatedDuration = Duration.zero;
      });

      ref.read(studyRunningProvider.notifier).state = false;
      _sessionId = 0;

      await _refreshFromServer();
    } catch (e) {
      print("endStudyTime 예외: $e");
      if (!mounted) return;
      ErrorDialog.show(context, "공부 종료 중 오류가 발생했습니다.");
    } finally {
      if (Theme.of(context).platform == TargetPlatform.iOS && _isTimerRunning) {
        try {
          await IosFocusControl.stopFocus();
        } catch (_) {}
      }
    }
  }

  void _startLocalTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => _updateTimerUI(),
    );
  }

  void _updateTimerUI() {
    if (_sessionStartTime == null) return;

    setState(() {
      _timerDuration =
          _accumulatedDuration + DateTime.now().difference(_sessionStartTime!);
    });
  }

  void _stopLocalTimer() => _timer?.cancel();

  void _startHeartBeat() {
    _heartBeatTimer?.cancel();
    _heartBeatTimer =
        Timer.periodic(const Duration(seconds: 30), (_) => _sendHeartBeat());
  }

  void _stopHeartBeat() => _heartBeatTimer?.cancel();

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
      ErrorDialog.show(context, res?.data.message ?? "하트비트 실패");
      await _endStudyInternal();
    }
  }

  Future<void> _refreshFromServer() async {
    final response = await ref.read(studyViewmodelProvider).getStudyTime();
    if (response == null) return;

    final totalMillis = response.data.totalStudySession;

    if (!_isTimerRunning) {
      setState(() {
        _timerDuration = Duration(milliseconds: totalMillis);
      });
    }

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
              spacing: 30,
              children: [
                const SizedBox(height: 60),
                Column(
                  children: [
                    CustomTimerWidget(duration: _timerDuration),
                    const SizedBox(height: 60),
                    TotalProgressDot(duration: _timerDuration),
                  ],
                ),
                SetBlockAppIcon(),
                StartAndStopBtn(
                  isTimerRunning: _isTimerRunning,
                  onStart: () async {
                    LoadingDialog.show(context);
                    try {
                      final now = DateTime.now();
                      final wifi = await vm.getWIFIInfo();

                      final res = await vm.startStudyTime(
                        StartStudyTimeRequestDto(
                          gatewayIp: wifi['gatewayIp'] ?? '',
                          clientIp: wifi['ip'] ?? '',
                        ),
                      );

                      LoadingDialog.hide(context);

                      if (res == null || !res.success) {
                        ErrorDialog.show(context, "교내 WIFI로 연결되어야 합니다.");
                        return;
                      }

                      _sessionId = res.data!.studySessionId;

                      if (Theme.of(context).platform == TargetPlatform.iOS) {
                        try {
                          await IosFocusControl.startFocus();
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  '차단 기능을 활성화하지 못했어요.\n'
                                      '집중 차단 설정을 다시 확인해주세요.',
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      }

                      setState(() {
                        _isTimerRunning = true;
                        _sessionStartTime = now;
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
                    await _endStudyInternal();
                    LoadingDialog.hide(context);
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
