import 'package:flutter/material.dart';
import 'package:geumpumta/screens/ranking/widgets/custom_select_button.dart';

enum StatsPeriodOption { daily, weekly, monthly }

class PeriodSelector extends StatefulWidget {
  const PeriodSelector({
    super.key,
    required this.selectedOption,
    required this.onChange,
  });

  final StatsPeriodOption selectedOption;
  final ValueChanged<StatsPeriodOption> onChange;

  @override
  State<PeriodSelector> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<PeriodSelector> {
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
              widget.onChange(StatsPeriodOption.daily);
            },
            text: '일간',
            isActive: widget.selectedOption == StatsPeriodOption.daily,
          ),
          CustomSelectButton(
            onClick: () {
              widget.onChange(StatsPeriodOption.weekly);
            },
            text: '주간',
            isActive: widget.selectedOption == StatsPeriodOption.weekly,
          ),
          CustomSelectButton(
            onClick: () {
              widget.onChange(StatsPeriodOption.monthly);
            },
            text: '월간',
            isActive: widget.selectedOption == StatsPeriodOption.monthly,
          ),
        ],
      ),
    );
  }
}

