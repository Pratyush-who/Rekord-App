import 'package:flutter/material.dart';
import '../utils/colors.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: Text(
          "Search",
          style: TextStyle(color: AppColors.primary, fontSize: 24),
        ),
      ),
      body: Center(
        child: Text(
          "Welcome to the Notifi Screen!",
          style: TextStyle(color: AppColors.white, fontSize: 20),
        ),
      ),
    );
  }
}
