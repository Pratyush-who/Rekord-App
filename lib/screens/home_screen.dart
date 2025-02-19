import 'package:flutter/material.dart';
import 'package:rekord/screens/explore_screen.dart';
import 'package:rekord/screens/notification_screen.dart';
import 'package:rekord/screens/post-section.dart';
import 'package:rekord/widgets/app_bar.dart';
import 'package:rekord/widgets/bottom_bar.dart';
import 'package:rekord/widgets/create-post-dialogue.dart';
import '../widgets/category_section.dart';
import '../utils/colors.dart';
import '../screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<PostSectionState> _postSectionKey = GlobalKey(); // Define the key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeContent(postSectionKey: _postSectionKey), // Pass the key here
      SearchScreen(),
      Container(), // Placeholder for the "+" button (no screen)
      NotificationsScreen(),
      ProfileScreen(),
    ];
  }

  void _openCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CreatePostDialog(
          onPostCreated: (String text, String? imagePath) {
            // Use the key to call addPost on the PostSectionState
            _postSectionKey.currentState?.addPost(text, imagePath);
          },
        );
      },
    );
  }


  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.black,
      endDrawer: _buildSideDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo.avif', height: 40),
        ),
        title: Text('Rekord', style: TextStyle(fontSize: 26, color: Colors.white)),
        actions: [
          GestureDetector(
            onTap: _openDrawer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/logo.avif'),
              ),
            ),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreatePostDialog,
        backgroundColor: AppColors.primary, // Orange background
        child: Icon(Icons.add, color: AppColors.white), // White "+" icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildSideDrawer() {
    return Drawer(
      backgroundColor: AppColors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.black,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/logo.avif'),
                ),
                SizedBox(height: 10),
                Text(
                  'Pratyush-who',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Sports Enthusiast',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.sports_soccer, 'Sports News'),
          _buildDrawerItem(Icons.calendar_today, 'Events'),
          _buildDrawerItem(Icons.group, 'Teams'),
          _buildDrawerItem(Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: TextStyle(color: AppColors.white)),
      onTap: () {},
    );
  }
}

class HomeContent extends StatelessWidget {
  final GlobalKey<PostSectionState> postSectionKey;

  HomeContent({required this.postSectionKey});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CategorySection(),
          SizedBox(height: 16),
          PostSection(key: postSectionKey), // Pass the key here
        ],
      ),
    );
  }
}