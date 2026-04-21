import 'package:flutter/material.dart';

class StartAndStopBtn extends StatefulWidget {
  const StartAndStopBtn({
    super.key,
    required this.isTimerRunning,
    this.isStarting = false,
    this.isStopping = false,
    required this.onStart,
    required this.onStop,
  });

  final bool isTimerRunning;
  final bool isStarting;
  final bool isStopping;
  final VoidCallback onStart;
  final VoidCallback onStop;

  @override
  State<StartAndStopBtn> createState() => _StartAndStopBtnState();
}

class _StartAndStopBtnState extends State<StartAndStopBtn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          !widget.isTimerRunning
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                    backgroundColor: const Color(0xFF0BAEFF),
                    disabledBackgroundColor: const Color(0xFF7ECFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: widget.isStarting ? null : widget.onStart,
                  child: widget.isStarting
                      ? const _StartButtonLoadingDots()
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              '시작하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(90, 90),
                    backgroundColor: const Color(0xFF0BAEFF),
                    disabledBackgroundColor: const Color(0xFF7ECFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: widget.isStopping ? null : widget.onStop,
                  child: widget.isStopping
                      ? const _StartButtonLoadingDots()
                      : const Icon(Icons.square_rounded, size: 50),
                ),
        ],
      ),
    );
  }
}

class _StartButtonLoadingDots extends StatefulWidget {
  const _StartButtonLoadingDots();

  @override
  State<_StartButtonLoadingDots> createState() => _StartButtonLoadingDotsState();
}

class _StartButtonLoadingDotsState extends State<_StartButtonLoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dot(double begin, double end) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.45, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(begin, end, curve: Curves.easeInOut),
        ),
      ),
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(0.0, 0.6),
        const SizedBox(width: 8),
        _dot(0.2, 0.8),
        const SizedBox(width: 8),
        _dot(0.4, 1.0),
      ],
    );
  }
}
