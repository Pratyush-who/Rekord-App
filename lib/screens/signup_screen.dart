import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

enum UserType { athlete, regularUser }

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Current user type
  UserType _userType = UserType.athlete;

  // Form controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _careerController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _interestsController = TextEditingController();

  DateTime? _selectedDate;
  File? _profileImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Colors
  final Color primaryRed = const Color(0xFFEE3124);
  final Color primaryOrange = const Color(0xFFFF7809);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ??
          DateTime.now().subtract(
              const Duration(days: 365 * 18)), // Default to 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryRed,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _signup(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Base data for both user types
      final Map<String, dynamic> userData = {
        'email': _emailController.text,
        'username': _usernameController.text,
        'name': _nameController.text,
        'password': _passwordController.text,
        'phone': _phoneController.text,
        'dateOfBirth': _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : null,
        'nationality': _nationalityController.text,
        'location': _locationController.text,
        'profileImage': _profileImage?.path ?? '',
        'userType': _userType == UserType.athlete ? 'athlete' : 'user',
      };

      // Add athlete-specific or user-specific data
      if (_userType == UserType.athlete) {
        userData.addAll({
          'career': _careerController.text,
          'bio': _bioController.text,
          'stats': {'totalMatches': 0, 'achievements': [], 'rankings': []}
        });
      } else {
        userData.addAll({
          'interests': _interestsController.text,
          'bio': _bioController.text,
          'following': [],
          'favoriteAthletes': []
        });
      }

      print('Submitting data: $userData');

      if (_userType == UserType.athlete) {
        Navigator.pushReplacementNamed(context, '/athlete_home',
            arguments: {'userType': 'athlete'});
      } else {
        Navigator.pushReplacementNamed(context, '/fan_home',
            arguments: {'userType': 'user'});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Color(0xFF212121)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // Logo and Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo.png', // Make sure to add a logo file
                          height: 40,
                          errorBuilder: (ctx, obj, trace) =>
                              Icon(Icons.sports, size: 40, color: primaryRed),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "REKORD",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // User Type Selector
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          // Athlete Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _userType = UserType.athlete;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                decoration: BoxDecoration(
                                  color: _userType == UserType.athlete
                                      ? primaryRed
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.sports,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "ATHLETE",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Regular User Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _userType = UserType.regularUser;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                decoration: BoxDecoration(
                                  color: _userType == UserType.regularUser
                                      ? primaryRed
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "FAN",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      _userType == UserType.athlete
                          ? "Create Your Athlete Profile"
                          : "Create Your Fan Profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Profile Image Picker
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : null,
                              child: _profileImage == null
                                  ? Icon(Icons.person,
                                      size: 50, color: Colors.grey[700])
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: primaryOrange,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Personal Information Section
                    _buildSectionTitle("Personal Information"),
                    _buildTextField(
                      controller: _nameController,
                      label: "Full Name",
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _usernameController,
                      label: "Username",
                      icon: Icons.alternate_email,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      label: "Password",
                      icon: Icons.lock,
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      icon: Icons.phone,
                    ),

                    const SizedBox(height: 16),
                    // Date of Birth Field
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Date of Birth",
                            labelStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(Icons.cake, color: primaryOrange),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white24),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: primaryRed),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                          ),
                          style: const TextStyle(color: Colors.white),
                          controller: TextEditingController(
                              text: _selectedDate != null
                                  ? DateFormat('dd/MM/yyyy')
                                      .format(_selectedDate!)
                                  : ''),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Location Information Section
                    _buildSectionTitle("Location Information"),
                    _buildTextField(
                      controller: _nationalityController,
                      label: "Nationality",
                      icon: Icons.flag,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _locationController,
                      label: "Current Location",
                      icon: Icons.location_on,
                    ),

                    const SizedBox(height: 24),

                    // Athlete-specific fields
                    if (_userType == UserType.athlete) ...[
                      _buildSectionTitle("Professional Information"),
                      _buildTextField(
                        controller: _careerController,
                        label: "Sports Career",
                        icon: Icons.sports_soccer,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _bioController,
                        label: "Athlete Bio",
                        icon: Icons.description,
                        maxLines: 3,
                      ),
                    ],

                    // User-specific fields
                    if (_userType == UserType.regularUser) ...[
                      _buildSectionTitle("Fan Information"),
                      _buildTextField(
                        controller: _interestsController,
                        label: "Favorite Sports",
                        icon: Icons.sports_baseball,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _bioController,
                        label: "Fan Bio",
                        icon: Icons.description,
                        maxLines: 3,
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Sign Up Button
                    ElevatedButton(
                      onPressed: () => _signup(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        _userType == UserType.athlete
                            ? "CREATE ATHLETE ACCOUNT"
                            : "CREATE FAN ACCOUNT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Login Link
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/'),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: Colors.white70),
                            ),
                            TextSpan(
                              text: "Login",
                              style: TextStyle(
                                color: primaryOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: primaryOrange,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: primaryOrange),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryRed),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
      validator: validator,
    );
  }
}
