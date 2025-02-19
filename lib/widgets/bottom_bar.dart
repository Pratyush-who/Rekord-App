import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const CustomBottomBar({
    required this.currentIndex,
    required this.onTabTapped,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(), // Creates a notch
      notchMargin: 10.0,
      color: AppColors.black.withOpacity(0.9), // Slight transparency
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: currentIndex == 0 ? AppColors.primary : AppColors.white,
            ),
            onPressed: () => onTabTapped(0),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: currentIndex == 1 ? AppColors.primary : AppColors.white,
            ),
            onPressed: () => onTabTapped(1),
          ),
          SizedBox(width: 40), // Empty space
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: currentIndex == 3 ? AppColors.primary : AppColors.white,
            ),
            onPressed: () => onTabTapped(3),
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: currentIndex == 4 ? AppColors.primary : AppColors.white,
            ),
            onPressed: () => onTabTapped(4),
          ),
        ],
      ),
    );
  }
}