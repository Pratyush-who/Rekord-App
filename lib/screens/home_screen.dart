import 'package:flutter/material.dart';
import 'package:rekord/screens/explore_screen.dart';
import 'package:rekord/screens/notification_screen.dart';
import 'package:rekord/screens/profile_screen.dart';
import 'package:rekord/widgets/app_bar.dart';
import 'package:rekord/widgets/bottom_bar.dart';
import 'package:rekord/widgets/create-post-dialogue.dart';
import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      UserHomeContent(),
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
            // Handle post creation
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

// User Home Content implementation from the second file
class UserHomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color primaryRed = const Color(0xFFEE3124);
    final Color primaryOrange = const Color(0xFFFF7809);
    
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message and quick stats
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryRed, primaryOrange],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome, Fan!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Stay connected with your favorite athletes",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard("Following", "32"),
                      _buildStatCard("Favorites", "12"),
                      _buildStatCard("Comments", "57"),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Featured Athletes Section
            Text(
              "FEATURED ATHLETES",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFeaturedAthleteCard(
                    name: "Alex Johnson",
                    sport: "Basketball",
                    image: "https://placehold.co/100x100",
                  ),
                  SizedBox(width: 12),
                  _buildFeaturedAthleteCard(
                    name: "Maria Silva",
                    sport: "Tennis",
                    image: "https://placehold.co/100x100",
                  ),
                  SizedBox(width: 12),
                  _buildFeaturedAthleteCard(
                    name: "James Wilson",
                    sport: "Soccer",
                    image: "https://placehold.co/100x100",
                  ),
                  SizedBox(width: 12),
                  _buildFeaturedAthleteCard(
                    name: "Li Wei",
                    sport: "Swimming",
                    image: "https://placehold.co/100x100",
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Upcoming Events
            Text(
              "UPCOMING EVENTS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 12),
            _buildEventCard(
              title: "International Championship",
              date: "Mar 15, 2025",
              location: "Sports Center, New York",
              icon: Icons.emoji_events,
            ),
            SizedBox(height: 12),
            _buildEventCard(
              title: "Local Tournament",
              date: "Mar 05, 2025",
              location: "City Arena",
              icon: Icons.sports,
            ),
            
            SizedBox(height: 24),
            
            // Latest Posts Section
            Text(
              "LATEST POSTS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 12),
            _buildPostCard(
              athleteName: "Alex Johnson",
              timeAgo: "2 hours ago",
              content: "Just finished an intense training session. Preparing for the big game next week!",
              likes: 245,
              comments: 37,
            ),
            SizedBox(height: 12),
            _buildPostCard(
              athleteName: "Maria Silva",
              timeAgo: "Yesterday",
              content: "Excited to announce my participation in the upcoming international tournament! 🏆",
              likes: 512,
              comments: 89,
              hasImage: true,
            ),
            
            SizedBox(height: 24),
            
            // Recommended For You
            Text(
              "RECOMMENDED FOR YOU",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Complete Your Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Add your favorite sports and interests to get personalized recommendations.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to profile editing
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "UPDATE PROFILE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeaturedAthleteCard({
    required String name,
    required String sport,
    required String image,
  }) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[800],
            backgroundImage: NetworkImage(image),
            onBackgroundImageError: (exception, stackTrace) => Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            sport,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              // Follow functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white60),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size(100, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text("Follow"),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEventCard({
    required String title,
    required String date,
    required String location,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.bookmark_border,
              color: Colors.white70,
            ),
            onPressed: () {
              // Save event functionality
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildPostCard({
    required String athleteName,
    required String timeAgo,
    required String content,
    required int likes,
    required int comments,
    bool hasImage = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header with athlete info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[800],
                child: Icon(Icons.person, color: Colors.white70),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    athleteName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          // Post content
          Text(
            content,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          
          // Post image if available
          if (hasImage) ...[
            SizedBox(height: 12),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage("https://placehold.co/600x400"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          
          SizedBox(height: 12),
          
          // Post actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: Colors.white70,
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    likes.toString(),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white70,
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    comments.toString(),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.share_outlined,
                color: Colors.white70,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}