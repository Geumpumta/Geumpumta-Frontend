import 'package:flutter/material.dart';
import 'package:geumpumta/widgets/section_title/section_title.dart';
import 'package:geumpumta/widgets/menu_item/menu_item.dart';
import 'package:geumpumta/screens/more/widgets/placeholder_screen.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({
    super.key,
    required this.title,
    required this.items,
    this.itemTextColor,
    this.itemIconColor,
  });

  final String title;
  final List<MenuItemData> items;
  final Color? itemTextColor;
  final Color? itemIconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: title),
          const SizedBox(height: 12),
          ...items.map((item) => MenuItem(
                title: item.title,
                textColor: itemTextColor ?? item.textColor,
                iconColor: itemIconColor ?? item.iconColor,
                onTap: item.onTap,
              )),
        ],
      ),
    );
  }
}

class MenuItemData {
  const MenuItemData({
    required this.title,
    this.onTap,
    this.textColor,
    this.iconColor,
  });

  final String title;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? iconColor;
}

