import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rekord/widgets/bottom_bar.dart';
import '../utils/colors.dart';
import 'dart:io';

class AthleteHomeScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const AthleteHomeScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _AthleteHomeScreenState createState() => _AthleteHomeScreenState();
}

class _AthleteHomeScreenState extends State<AthleteHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  late List<Widget> _screens;
  final PostSectionState _postSectionState = PostSectionState();

  @override
  void initState() {
    super.initState();
    _screens = [
      AthleteHomeContent(
        userData: widget.userData,
        postSection: PostSection(key: GlobalKey<PostSectionState>(), state: _postSectionState),
      ),
      SearchScreen(),
      Container(), // Placeholder for the "+" button (no screen)
      NotificationsScreen(),
      ProfileScreen(),
    ];
  }

  void _openCreatePostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePostScreen(
          onPostCreated: (String text, String? imagePath) {
            _postSectionState.addPost(text, imagePath);
          },
        ),
      ),
    );
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      // If center tab is tapped (index 2), open create post screen
      _openCreatePostScreen();
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _logout() {
    // Navigate back to login screen
    Navigator.pushReplacementNamed(context, '/');
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
        onPressed: _openCreatePostScreen,
        backgroundColor: const Color(0xFFEE3124), // Primary red color
        child: Icon(Icons.add, color: AppColors.white),
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
                  widget.userData['name'] ?? 'Athlete',
                  style: TextStyle(
                    color: const Color(0xFFFF7809), // Primary orange color
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.userData['career'] ?? 'Professional Athlete',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.analytics, 'Performance Stats'),
          _buildDrawerItem(Icons.sports, 'My Career'),
          _buildDrawerItem(Icons.calendar_today, 'Upcoming Events'),
          _buildDrawerItem(Icons.people, 'My Fans'),
          _buildDrawerItem(Icons.settings, 'Settings'),
          Divider(color: Colors.white24),
          ListTile(
            leading: Icon(Icons.logout, color: const Color(0xFFEE3124)),
            title: Text('Logout', style: TextStyle(color: AppColors.white)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFF7809)),
      title: Text(title, style: TextStyle(color: AppColors.white)),
      onTap: () {},
    );
  }
}

// Athlete Home Content
class AthleteHomeContent extends StatelessWidget {
  final Map<String, dynamic> userData;
  final PostSection postSection;

  const AthleteHomeContent({
    Key? key,
    required this.userData,
    required this.postSection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryRed = const Color(0xFFEE3124);
    final Color primaryOrange = const Color(0xFFFF7809);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message and quick stats
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
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
                    "Welcome, ${userData['name'] ?? 'Athlete'}!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Manage your career and connect with fans",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard("Fans", "1.2M"),
                      _buildStatCard("Posts", "42"),
                      _buildStatCard("Reach", "16.9M"),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Fan Engagement
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "FAN ENGAGEMENT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),

          SizedBox(height: 12),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.insights, color: primaryOrange, size: 24),
                      SizedBox(width: 12),
                      Text(
                        "Engagement Stats",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildEngagementStat("Profile Views", "0"),
                      _buildEngagementStat("Post Engagement", "0%"),
                      _buildEngagementStat("Fan Growth", "0%"),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "YOUR POSTS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          
          SizedBox(height: 8),
          
          // Post Section
          SizedBox(
            height: 400, // Fixed height for post section
            child: postSection,
          ),
        ],
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

  Widget _buildEngagementStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// Create Post Screen (Full page instead of dialog)
class CreatePostScreen extends StatefulWidget {
  final Function(String text, String? imagePath) onPostCreated;

  const CreatePostScreen({Key? key, required this.onPostCreated}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _imagePath;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  void _createPost() {
    final text = _textController.text.trim();
    if (text.isNotEmpty || _imagePath != null) {
      widget.onPostCreated(text, _imagePath);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: Text('Create Post', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _createPost,
            child: Text(
              'Post',
              style: TextStyle(
                color: const Color(0xFFEE3124),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/logo.avif'),
                  radius: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Create a post as ${UserData.name ?? "Athlete"}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _textController,
                style: TextStyle(color: Colors.white),
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
            if (_imagePath != null)
              Container(
                height: 200,
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(File(_imagePath!)),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: Colors.white, size: 16),
                    ),
                    onPressed: () {
                      setState(() {
                        _imagePath = null;
                      });
                    },
                  ),
                ),
              ),
            Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white24, width: 1),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.image, color: Colors.white70),
                    onPressed: _pickImage,
                  ),
                  Text(
                    'Add Photo',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Post Section Widget
class PostSection extends StatefulWidget {
  final PostSectionState state;

  PostSection({Key? key, required this.state}) : super(key: key);

  @override
  PostSectionState createState() => state;
}

class PostSectionState extends State<PostSection> {
  List<Map<String, dynamic>> posts = [
    {
      "text": "What a hackathon! We won CODESEVA 🧑‍💻👾 #Hackathon #CodeSeva",
      "image": "assets/post1.jpg",
      "time": DateTime.now().subtract(Duration(hours: 2)),
      "isAsset": true,
    },
    {
      "text": "Just finished a 10k run! 🏃‍♂️💨 #Fitness #Running",
      "image": "assets/post2.png",
      "time": DateTime.now().subtract(Duration(days: 1)),
      "isAsset": true,
    },
    {
      "text": "Incredible goal by my favorite player! ⚽️🔥 #Football",
      "image": "assets/post3.webp",
      "time": DateTime.now().subtract(Duration(minutes: 45)),
      "isAsset": true,
    },
    {
      "text": "Amazing rally in today's tennis match! 🎾💪 #Tennis",
      "image": "assets/post4.avif",
      "time": DateTime.now().subtract(Duration(hours: 3)),
      "isAsset": true,
    },
    {
      "text": "Preparikjhgng for thefnakjf big championship next week! 💪 #Championship #Training",
      "image": "assets/post5.png",
      "time": DateTime.now().subtract(Duration(days: 2)),
      "isAsset": true,
    },
    {
      "text": "Thank you to all my fans for the support! You make this journey worth it. ❤️ #Grateful",
      "image": null,
      "time": DateTime.now().subtract(Duration(days: 3)),
      "isAsset": true,
    },
  ];

  void addPost(String text, String? imagePath) {
    setState(() {
      posts.insert(0, {
        "text": text,
        "image": imagePath,
        "time": DateTime.now(),
        "isAsset": imagePath == null ? true : false,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final time = post["time"] as DateTime;
        final timeAgo = _getTimeAgo(time);

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: AppColors.darkGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post Header
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage("assets/logo.avif"),
                ),
                title: Text(
                  UserData.name ?? "Athlete",
                  style: TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  timeAgo,
                  style: TextStyle(color: AppColors.lightGrey),
                ),
                trailing: Icon(
                  Icons.more_vert,
                  color: AppColors.white,
                ),
              ),
              // Post Text
              if (post["text"] != null && post["text"].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    post["text"],
                    style: TextStyle(color: AppColors.white, fontSize: 15),
                  ),
                ),
              // Post Image
              if (post["image"] != null)
                post["isAsset"]
                    ? Image.asset(
                        post["image"],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300,
                      )
                    : Image.file(
                        File(post["image"]),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300,
                      ),

              // Post Actions
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border, color: AppColors.white),
                      onPressed: () {},
                    ),
                    Text(
                      "${index * 24 + 12}",
                      style: TextStyle(color: AppColors.white),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.comment, color: AppColors.white),
                      onPressed: () {},
                    ),
                    Text(
                      "${index * 5 + 3}",
                      style: TextStyle(color: AppColors.white),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.share, color: AppColors.white),
                      onPressed: () {},
                    ),
                    Text(
                      "${index + 1}",
                      style: TextStyle(color: AppColors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago";
    } else {
      return "Just now";
    }
  }
}

// These should be defined elsewhere in your app
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Search Screen",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Notifications Screen",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Profile Screen",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

// Static class for user data (simplified approach)
class UserData {
  static String? name = "Athlete Name";
}

// Ensure you have these colors defined in your AppColors class
class AppColors {
  static const black = Color(0xFF121212);
  static const darkGrey = Color(0xFF1E1E1E);
  static const lightGrey = Color(0xFFAAAAAA);
  static const white = Colors.white;
}