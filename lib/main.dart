import 'package:flutter/material.dart';
import 'package:rekord/navigation/app_router.dart';
import 'package:rekord/utils/colors.dart';

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
        primaryColor: AppColors.black,
        scaffoldBackgroundColor: AppColors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.black,
          elevation: 0,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.white),
          bodyMedium: TextStyle(color: AppColors.white),
        ),
      ),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/', // Start with LoginScreen
    );
  }
}