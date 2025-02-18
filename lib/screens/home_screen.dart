import 'package:flutter/material.dart';
import 'package:rekord/screens/post-section.dart';
import 'package:rekord/widgets/app_bar.dart';
import 'package:rekord/widgets/bottom_bar.dart';
import 'package:rekord/widgets/create-post-dialogue.dart';
import '../widgets/category_section.dart';
import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<PostSectionState> _postSectionKey = GlobalKey();

  void _openCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CreatePostDialog(
          onPostCreated: (String text, String? imagePath) {
            _postSectionKey.currentState?.addPost(text, imagePath);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CategorySection(),
            SizedBox(height: 16),
            PostSection(key: _postSectionKey), // Pass the key to PostSection
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        onAddPost: _openCreatePostDialog, // Open the create post dialog
      ),
    );
  }
}