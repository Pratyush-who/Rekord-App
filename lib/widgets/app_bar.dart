import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:18.0),
      child: AppBar(
        backgroundColor: AppColors.black,
        title: Text(
          "Rekordd",
          style: TextStyle(color: AppColors.primary, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.comment, color: AppColors.white),
            onPressed: () {
              // Add category logic
            },
          ),
        ],
      ),
    );
  }
}
