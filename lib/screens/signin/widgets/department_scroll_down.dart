import 'package:flutter/material.dart';
import 'package:geumpumta/models/department.dart';

class DepartmentScrollDown extends StatelessWidget {
  const DepartmentScrollDown({
    super.key,
    required this.selected,
    required this.searchText,
    this.onDepartmentSelected,
  });

  final String selected;
  final String searchText;
  final ValueChanged<Department>? onDepartmentSelected;

  @override
  Widget build(BuildContext context) {
    final allDept = Department.values;

    final filtered = allDept.where((d) {
      if (d == Department.none) return false;
      final name = d.koreanName;
      if (searchText.isEmpty) return true;
      return name.contains(searchText);
    }).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: filtered.map((dept) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              alignment: Alignment.centerLeft,
              foregroundColor: Colors.black,
              backgroundColor: dept.koreanName == selected
                  ? const Color(0x110BAEFF)
                  : const Color(0xFFFFFFFF),
              overlayColor: const Color(0xFFE0F7FA),
            ),
            onPressed: () => onDepartmentSelected?.call(dept),
            child: Row(
              children: [
                Text(
                  dept.koreanName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                if (dept.koreanName == selected)
                  Image.asset(
                    'assets/image/signin/selected_check_icon.png',
                    height: 20,
                    width: 30,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
