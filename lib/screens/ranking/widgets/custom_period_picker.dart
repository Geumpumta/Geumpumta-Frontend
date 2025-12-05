import 'package:flutter/material.dart';
import 'package:geumpumta/screens/ranking/ranking.dart';

class CustomPeriodPicker extends StatefulWidget {
  const CustomPeriodPicker({
    super.key,
    required this.option,
    required this.selectedDate,
    required this.onSelect,
  });

  final PeriodOption option;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelect;

  @override
  State<CustomPeriodPicker> createState() => _CustomPeriodPickerState();
}

class _CustomPeriodPickerState extends State<CustomPeriodPicker> {
  @override
  Widget build(BuildContext context) {
    int getWeekOfMonth(DateTime date) {
      DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
      int firstWeekday = firstDayOfMonth.weekday;

      int dayOfMonth = date.day;

      return ((dayOfMonth + firstWeekday - 1) / 7).ceil();
    }

    String formattedViewText(DateTime date) {
      if (widget.option == PeriodOption.daily)
        return '${widget.selectedDate.year}.${widget.selectedDate.month}.${widget.selectedDate.day}';
      else if (widget.option == PeriodOption.weekly)
        return '${widget.selectedDate.month}월 ${getWeekOfMonth(widget.selectedDate)}주차';
      else
        return '${widget.selectedDate.year}.${widget.selectedDate.month}';
    }

    bool canIncrease(DateTime date) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final next = date.add(const Duration(days: 1));
      final nextDate = DateTime(next.year, next.month, next.day);

      return !nextDate.isAfter(today);
    }

    final isIncreaseEnabled = canIncrease(widget.selectedDate);

    void decreaseDate() {
      if (widget.option == PeriodOption.daily)
        widget.onSelect(widget.selectedDate.subtract(const Duration(days: 1)));
      else if (widget.option == PeriodOption.weekly)
        widget.onSelect(widget.selectedDate.subtract(const Duration(days: 7)));
      else
        widget.onSelect(
          DateTime(widget.selectedDate.year, widget.selectedDate.month - 1, 1),
        );
    }

    void increaseDate() {
      if (widget.option == PeriodOption.daily)
        widget.onSelect(widget.selectedDate.add(const Duration(days: 1)));
      else if (widget.option == PeriodOption.weekly)
        widget.onSelect(widget.selectedDate.add(const Duration(days: 7)));
      else
        widget.onSelect(
          DateTime(widget.selectedDate.year, widget.selectedDate.month + 1, 1),
        );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            decreaseDate();
          },
          icon: Icon(Icons.chevron_left),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            formattedViewText(widget.selectedDate),
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          onPressed: isIncreaseEnabled ? increaseDate : null,
          icon: Icon(
            Icons.chevron_right,
            color: isIncreaseEnabled ? Colors.black : Color(0xFFD9D9D9),
          ),
        ),
      ],
    );
  }
}
