import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geumpumta/screens/ranking/widgets/default_ranking.dart';
import 'package:geumpumta/screens/ranking/widgets/season_ranking.dart';

enum RankingTab { ranking, season }

extension RankingTabExtension on RankingTab {
  String get label {
    switch (this) {
      case RankingTab.ranking:
        return '랭킹';
      case RankingTab.season:
        return '시즌';
    }
  }
}

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen> {
  RankingTab _selectedTab = RankingTab.ranking;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _RankingPopupHeader(
            value: _selectedTab,
            onSelected: (v) => setState(() => _selectedTab = v),
          ),
          Expanded(
            child: _selectedTab == RankingTab.ranking
                ? const DefaultRanking()
                : const SeasonRanking(),
          ),
        ],
      ),
    );
  }
}

class _RankingPopupHeader extends StatelessWidget {
  final RankingTab value;
  final ValueChanged<RankingTab> onSelected;

  const _RankingPopupHeader({
    required this.value,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Center(
        child: Builder(
          builder: (btnContext) {
            return GestureDetector(
              onTap: () => _showCenteredMenu(
                context: btnContext,
                current: value,
                onSelected: onSelected,
              ),
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    value.label,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.expand_more, size: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showCenteredMenu({
    required BuildContext context,
    required RankingTab current,
    required ValueChanged<RankingTab> onSelected,
  }) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset buttonTopLeft = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    const double menuWidth = 180;
    const double menuTopGap = 8;

    final double buttonCenterX = buttonTopLeft.dx + button.size.width / 2;
    final double left = buttonCenterX - menuWidth / 2;
    final double top = buttonTopLeft.dy + button.size.height + menuTopGap;

    final double safeLeft = left.clamp(8.0, overlay.size.width - menuWidth - 8);
    final double right = overlay.size.width - safeLeft - menuWidth;

    final RelativeRect position = RelativeRect.fromLTRB(
      safeLeft,
      top,
      right,
      0,
    );

    final result = await showMenu<RankingTab>(
      context: context,
      position: position,
      color: Colors.white,
      elevation: 6,
      constraints: const BoxConstraints.tightFor(width: menuWidth),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),

      items: RankingTab.values.map((e) {
        final isSelected = e == current;

        return _MenuEntry<RankingTab>(
          value: e,
          height: 48,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFEAF6FF) : Colors.transparent,
            ),
            child: Row(
              children: [
                Text(
                  e.label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2F80ED),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );

    if (result != null) {
      onSelected(result);
    }
  }
}

class _MenuEntry<T> extends PopupMenuEntry<T> {
  final T value;
  final Widget child;
  final double _height;

  const _MenuEntry({
    required this.value,
    required this.child,
    double height = 48,
  }) : _height = height;

  @override
  double get height => _height;

  @override
  bool represents(T? value) => this.value == value;

  @override
  State<_MenuEntry<T>> createState() => _MenuEntryState<T>();
}

class _MenuEntryState<T> extends State<_MenuEntry<T>> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop<T>(context, widget.value),
      child: widget.child,
    );
  }
}
