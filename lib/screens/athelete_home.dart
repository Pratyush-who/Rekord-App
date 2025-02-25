import 'package:flutter/material.dart';
import 'package:rekord/widgets/bottom_bar.dart';
import '../utils/colors.dart';

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

  @override
  void initState() {
    super.initState();
    _screens = [
      AthleteHomeContent(userData: widget.userData),
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
            // Handle post creation (athlete specific)
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
        title:
            Text('Rekord', style: TextStyle(fontSize: 26, color: Colors.white)),
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

  const AthleteHomeContent({Key? key, required this.userData})
      : super(key: key);

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
                      _buildStatCard("Fans", "0"),
                      _buildStatCard("Posts", "0"),
                      _buildStatCard("Reach", "0"),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Career Highlights Section
            Text(
              "CAREER HIGHLIGHTS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 12),
            _buildCareerCard(
              "Add your first career highlight",
              "Share your greatest achievements with fans",
              isPlaceholder: true,
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
              title: "No Upcoming Events",
              date: "Add your first event",
              location: "Schedule your games and tournaments",
              icon: Icons.calendar_today,
              isPlaceholder: true,
            ),

            SizedBox(height: 24),

            // Fan Engagement
            Text(
              "FAN ENGAGEMENT",
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

            SizedBox(height: 24),

            // Action Items
            Text(
              "ACTIONS",
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
                    "Add your achievements, statistics, and career highlights to attract more fans.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to profile editing
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryRed,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "EDIT PROFILE",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Create new post
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryOrange,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "CREATE POST",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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

  Widget _buildCareerCard(String title, String description,
      {bool isPlaceholder = false}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border:
            isPlaceholder ? Border.all(color: Colors.white24, width: 1) : null,
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
              Icons.emoji_events,
              color: Colors.amber,
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
                  description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          isPlaceholder
              ? IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: const Color(0xFFFF7809),
                  ),
                  onPressed: () {
                    // Add career highlight
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    // Edit career highlight
                  },
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
    bool isPlaceholder = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border:
            isPlaceholder ? Border.all(color: Colors.white24, width: 1) : null,
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
          isPlaceholder
              ? IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: const Color(0xFFFF7809),
                  ),
                  onPressed: () {
                    // Add event
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    // Edit event
                  },
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

class CreatePostDialog extends StatefulWidget {
  final Function(String, String?) onPostCreated;

  const CreatePostDialog({Key? key, required this.onPostCreated})
      : super(key: key);

  @override
  _CreatePostDialogState createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final TextEditingController _textController = TextEditingController();
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        "Create Post",
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            style: TextStyle(color: Colors.white),
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "What's on your mind?",
              hintStyle: TextStyle(color: Colors.white54),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.image, color: Colors.white70),
                onPressed: () {
                  // Image pick functionality would go here
                  setState(() {
                    _imagePath = "dummy_path";
                  });
                },
              ),
              _imagePath != null
                  ? Text(
                      "Image selected",
                      style: TextStyle(color: Colors.white70),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text("Cancel", style: TextStyle(color: Colors.white70)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEE3124),
          ),
          child: Text("Post"),
          onPressed: () {
            widget.onPostCreated(_textController.text, _imagePath);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
