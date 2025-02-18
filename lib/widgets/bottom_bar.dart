import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomBottomBar extends StatelessWidget {
  final Function() onAddPost;

  const CustomBottomBar({required this.onAddPost});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home, color: AppColors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search, color: AppColors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add, color: AppColors.white),
            onPressed: onAddPost, // Trigger the add post function
          ),
          IconButton(
            icon: Icon(Icons.music_video_sharp, color: AppColors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person, color: AppColors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
