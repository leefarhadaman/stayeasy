import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getapg/screens/pg_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controllers/app_controller.dart';
import 'screens/explore_screen.dart';
import 'screens/main_screen.dart';

void main() {
  Get.put(AppController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'StayEasy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[300],
        scaffoldBackgroundColor: Colors.blue[50],
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: Colors.grey[900],
          displayColor: Colors.grey[900],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: Colors.blue[300],
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blue[100]!),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
      ),
      home: const MainScreen(),
      getPages: [
        GetPage(name: '/explore', page: () => const ExploreScreen()),
        GetPage(name: '/pg_detail', page: () => PgDetailScreen(pg: Get.arguments)),
      ],
    );
  }
}