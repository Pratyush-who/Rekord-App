import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;

  CustomAppBar({required this.onMenuPressed});

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.black,
      title: Text(
        "Rekordd",
        style: TextStyle(color: AppColors.primary, fontSize: 24),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.menu, color: AppColors.primary),
          onPressed: onMenuPressed,
        ),
      ],
    );
  }
}