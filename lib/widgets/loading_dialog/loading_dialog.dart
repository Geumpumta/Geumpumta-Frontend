import 'package:flutter/material.dart';

class LoadingDialog {
  static bool _isShown = false;

  static void show(BuildContext context) {
    if (_isShown) return;
    _isShown = true;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.45),
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (_, __, ___) {
        return const _FullScreenLoader();
      },
    );
  }

  static void hide(BuildContext context) {
    if (_isShown) {
      _isShown = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

class _FullScreenLoader extends StatelessWidget {
  const _FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: _ThreeDotLoading(),
    );
  }
}

class _ThreeDotLoading extends StatefulWidget {
  const _ThreeDotLoading({super.key});

  @override
  State<_ThreeDotLoading> createState() => _ThreeDotLoadingState();
}

class _ThreeDotLoadingState extends State<_ThreeDotLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dot1;
  late Animation<double> _dot2;
  late Animation<double> _dot3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();

    _dot1 = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _dot2 = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );

    _dot3 = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return ScaleTransition(
      scale: animation,
      child: Container(
        width: 16,
        height: 16,
        decoration: const BoxDecoration(
          color: Color(0xFF0BAEFF),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(_dot1),
        const SizedBox(width: 12),
        _buildDot(_dot2),
        const SizedBox(width: 12),
        _buildDot(_dot3),
      ],
    );
  }
}
