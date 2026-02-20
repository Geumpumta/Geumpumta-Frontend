import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onTap;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (btnContext) {
        return GestureDetector(
          onTap: () => _showMenu(
            context: btnContext,
            current: value,
            items: items,
            onSelected: onTap,
          ),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 28,
                color: Colors.black,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showMenu({
    required BuildContext context,
    required String current,
    required List<String> items,
    required ValueChanged<String?> onSelected,
  }) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset buttonTopLeft =
    button.localToGlobal(Offset.zero, ancestor: overlay);

    const double menuWidth = 180;
    const double menuTopGap = 8;

    final double buttonCenterX = buttonTopLeft.dx + button.size.width / 2;
    final double left = buttonCenterX - menuWidth / 2;
    final double top = buttonTopLeft.dy + button.size.height + menuTopGap;

    final double safeLeft =
    left.clamp(8.0, overlay.size.width - menuWidth - 8);
    final double right = overlay.size.width - safeLeft - menuWidth;

    final RelativeRect position = RelativeRect.fromLTRB(
      safeLeft,
      top,
      right,
      0,
    );

    final result = await showMenu<String>(
      context: context,
      position: position,
      color: Colors.white,
      elevation: 6,
      constraints: const BoxConstraints.tightFor(width: menuWidth),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      items: items.map((item) {
        final bool isSelected = item == current;

        return _MenuEntry<String>(
          value: item,
          height: 48,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color:
              isSelected ? const Color(0xFFEAF6FF) : Colors.transparent,
            ),
            child: Row(
              children: [
                Text(
                  item,
                  style: const TextStyle(
                    fontSize: 20,
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
