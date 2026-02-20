import 'package:flutter/material.dart';
import 'package:geumpumta/screens/ranking/ranking.dart';
import 'package:geumpumta/screens/ranking/widgets/custom_select_button.dart';
import 'package:geumpumta/screens/ranking/widgets/period_option.dart';

class PerDayOrWeekOrMonth extends StatefulWidget {
  const PerDayOrWeekOrMonth({
    super.key,
    required this.selectedOption,
    required this.onChange,
  });

  final PeriodOption selectedOption;
  final ValueChanged<PeriodOption> onChange;

  @override
  State<PerDayOrWeekOrMonth> createState() => _PerDayOrWeekOrMonthState();
}

class _PerDayOrWeekOrMonthState extends State<PerDayOrWeekOrMonth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFD9D9D9))),
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomSelectButton(
            onClick: () {
              widget.onChange(PeriodOption.daily);
            },
            text: '일간',
            isActive: widget.selectedOption == PeriodOption.daily,
          ),
          CustomSelectButton(
            onClick: () {
              widget.onChange(PeriodOption.weekly);
            },
            text: '주간',
            isActive: widget.selectedOption == PeriodOption.weekly,
          ),
          CustomSelectButton(
            onClick: () {
              widget.onChange(PeriodOption.monthly);
            },
            text: '월간',
            isActive: widget.selectedOption == PeriodOption.monthly,
          ),
        ],
      ),
    );
  }
}
