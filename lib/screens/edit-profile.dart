import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = true;
  Map<String, dynamic> userData = {};
  
  // Text controllers for editable fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _sportsController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _dobController.dispose();
    _sportsController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get the full user data
      final userDataString = prefs.getString('userData');
      
      if (userDataString != null) {
        final data = jsonDecode(userDataString);
        setState(() {
          userData = data;
          
          // Set initial values for text controllers
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _locationController.text = data['location'] ?? '';
          _dobController.text = data['dateOfBirth'] ?? '';
          
          // Handle sports which might be a list
          if (data.containsKey('sports')) {
            if (data['sports'] is List) {
              _sportsController.text = data['sports'].join(', ');
            } else {
              _sportsController.text = data['sports'].toString();
            }
          }
          
          isLoading = false;
        });
      } else {
        // If no full data, try to get individual fields
        final email = prefs.getString('email') ?? '';
        
        setState(() {
          _emailController.text = email;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  
  Future<void> _saveChanges() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      final prefs = await SharedPreferences.getInstance();
      
      // Update user data
      userData['name'] = _nameController.text;
      userData['email'] = _emailController.text;
      userData['phone'] = _phoneController.text;
      userData['location'] = _locationController.text;
      userData['dateOfBirth'] = _dobController.text;
      
      // Handle sports (convert comma-separated string to list)
      final sportsList = _sportsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      userData['sports'] = sportsList;
      
      // Save to SharedPreferences
      await prefs.setString('userData', jsonEncode(userData));
      
      // Also update individual fields
      await prefs.setString('email', _emailController.text);
      
      setState(() {
        isLoading = false;
      });
      
      // Go back to profile page
      Navigator.pop(context);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      print('Error saving profile changes: $e');
      setState(() {
        isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: userData.containsKey('profilePicture') ? 
                        NetworkImage(userData['profilePicture']) : null,
                    child: !userData.containsKey('profilePicture') ? 
                        const Icon(Icons.person, size: 60, color: Colors.grey) : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        onPressed: () {
                          // Implement image selection functionality
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Name
            _buildTextField('Name', 'Enter your name', _nameController),
            
            // Email
            _buildTextField('Email', 'Enter your email', _emailController),
            
            // Phone
            _buildTextField('Phone', 'Enter your phone number', _phoneController),
            
            // Date of Birth
            _buildTextField('Date of Birth', 'YYYY-MM-DD', _dobController),
            
            // Location
            _buildTextField('Location', 'City, Country', _locationController),
            
            // Sports (for athletes)
            if (userData['userType'] == 'athlete')
              _buildTextField('Sports', 'Enter sports (comma separated)', _sportsController),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}