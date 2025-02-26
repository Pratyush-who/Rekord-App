import 'package:flutter/material.dart';
import 'package:rekord/screens/athelete_home.dart';
import 'package:rekord/screens/edit-profile.dart';
import 'package:rekord/screens/explore_screen.dart';
import 'package:rekord/screens/fan_home.dart';
import 'package:rekord/screens/notification_screen.dart';
import 'package:rekord/screens/login_screen.dart';
import 'package:rekord/screens/signup_screen.dart';
import 'package:rekord/screens/profile_screen.dart';
import 'package:rekord/screens/test_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Extract arguments if available
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case '/postspage':
        return MaterialPageRoute(builder: (_) => PostsPage());
      case '/athlete_home':
        return MaterialPageRoute(
          builder: (_) => AthleteHomeScreen(
            userData: args ?? {},
          ),
        );
      case '/fan_home':
        return MaterialPageRoute(
          builder: (_) => FanHomeScreen(
            userData: args,
          ),
        );
      // case '/search':
      //   return MaterialPageRoute(builder: (_) => SearchScreen());
      // case '/notifications':
      //   return MaterialPageRoute(builder: (_) => NotificationsScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case '/edit-profile':
        return MaterialPageRoute(builder: (_) => EditProfileScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}',
                  style: TextStyle(color: Colors.white)),
            ),
            backgroundColor: Colors.black,
          ),
        );
    }
  }
}