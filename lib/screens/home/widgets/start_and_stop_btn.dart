import 'package:flutter/material.dart';

class StartAndStopBtn extends StatefulWidget {
  const StartAndStopBtn({
    super.key,
    required this.isTimerRunning,
    required this.onStart,
    required this.onStop,
  });

  final bool isTimerRunning;
  final VoidCallback onStart;
  final VoidCallback onStop;

  @override
  State<StartAndStopBtn> createState() => _StartAndStopBtnState();
}

class _StartAndStopBtnState extends State<StartAndStopBtn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          !widget.isTimerRunning
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                    backgroundColor: const Color(0xFF0BAEFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: widget.onStart,
                  child: const Row(
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: widget.onStop,
                  child: Icon(Icons.square_rounded, size: 50),
                ),
        ],
      ),
    );
  }
}
