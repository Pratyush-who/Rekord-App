import 'package:flutter/material.dart';
import 'package:rekord/navigation/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Rekord',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/', // Start with LoginScreen
      //testing
    );
  }
}