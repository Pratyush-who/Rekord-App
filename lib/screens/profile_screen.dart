import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;
  Map<String, dynamic> userData = {};
  String userType = '';
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // First try to get the entire user data object
      final userDataString = prefs.getString('userData');
      print(userDataString);
      if (userDataString != null) {
        setState(() {
          userData = jsonDecode(userDataString);
        });
      } else {
        // If full userData object isn't available, try to build it from individual fields
        final token = prefs.getString('token') ?? '';
        final userId = prefs.getString('userId') ?? '';
        final email = prefs.getString('email') ?? '';
        final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
        
        setState(() {
          userData = {
            'token': token,
            'userId': userId,
            'email': email,
            'isLoggedIn': isLoggedIn,
          };
        });
      }
      
      // Get user type
      final type = prefs.getString('userType') ?? '';
      setState(() {
        userType = type;
        isLoading = false;
      });
      
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  
  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      // You might want to clear other user data as well
      await prefs.remove('userData');
      await prefs.remove('token');
      await prefs.remove('userId');
      await prefs.remove('email');
      
      // Navigate to login screen or home screen
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit profile page
              Navigator.of(context).pushNamed('/edit-profile');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Profile picture
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: userData.containsKey('profilePicture') && userData['profilePicture'] != null
                    ? NetworkImage(userData['profilePicture'])
                    : null,
                child: !userData.containsKey('profilePicture') || userData['profilePicture'] == null
                    ? const Icon(Icons.person, size: 60, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 16),
              
              // Name
              Text(
                userData.containsKey('name') ? userData['name'] : 'Athlete',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              
              // User type badge
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  userType.isNotEmpty ? userType.toUpperCase() : 'ATHLETE',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              const Divider(),
              
              // User information
              _buildInfoItem(Icons.email, 'Email', 
                userData.containsKey('email') ? userData['email'] : 'Not provided'),
              
              _buildInfoItem(Icons.phone, 'Phone', 
                userData.containsKey('phone') ? userData['phone'] : 'Not provided'),
              
              _buildInfoItem(Icons.cake, 'Date of Birth', 
                userData.containsKey('dateOfBirth') ? userData['dateOfBirth'] : 'Not provided'),
              
              _buildInfoItem(Icons.location_on, 'Location', 
                userData.containsKey('location') ? userData['location'] : 'Not provided'),
              
              // If athlete, show sports/activities
              if (userType.toLowerCase() == 'athlete')
                _buildInfoItem(Icons.sports, 'Sports', 
                  userData.containsKey('sports') 
                    ? (userData['sports'] is List 
                        ? userData['sports'].join(', ') 
                        : userData['sports'].toString())
                    : 'Not provided'),
              
              const SizedBox(height: 20),
              const Divider(),
              
              // Logout button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}