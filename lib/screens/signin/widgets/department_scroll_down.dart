import 'package:flutter/material.dart';
import 'package:geumpumta/models/department.dart';

class DepartmentScrollDown extends StatelessWidget {
  const DepartmentScrollDown({
    super.key,
    required this.selected,
    this.onDepartmentSelected,
  });
  final String selected;
  final ValueChanged<Department>? onDepartmentSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: Department.values.map((dept) {
        if (dept == Department.none) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              alignment: Alignment.centerLeft,
              foregroundColor: Colors.black,
              backgroundColor: dept.koreanName==selected ? Color(0x110BAEFF):Color(0xFFFFFFFF),
              overlayColor: const Color(0xFFE0F7FA),
            ),
            onPressed: () => onDepartmentSelected?.call(dept),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  dept.koreanName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                dept.koreanName == selected
                    ? Image.asset(
                  'assets/image/signin/selected_check_icon.png', height: 20,width: 30,)
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
