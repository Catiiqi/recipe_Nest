import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipenest/util/provider/favorateProvider.dart';
import 'Authentication/auth_gate.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'util/provider/ProfileImageProvider.dart';
import 'util/provider/recipe_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'home_page.dart';
import 'pages/add_recipe_page.dart';
import 'pages/recipe_detail_page.dart';
import 'pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
      url: 'https://zhazbgjgaktesuytljzn.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpoYXpiZ2pnYWt0ZXN1eXRsanpuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc0Njk2NTIsImV4cCI6MjA1MzA0NTY1Mn0.nrLVTX2rSHYliqNVAKvgbY-7X81eQmZAiM0G_0IySJw');
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ChangeNotifierProvider(create: (_) => ProfileImageProvider()),
      ChangeNotifierProvider(create: (_) => FavoriteProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF8B4513), // Brown
          secondary: Color(0xFFFFA500), // Orange
          background: Color(0xFFFFF5E1), // Cream/Beige
          surface: Color(0xFFFFF5E1), // White
          onPrimary: Colors.white, // Text on primary color
          onSecondary: Colors.white, // Text on secondary color
          onBackground: Color(0xFF333333), // Text on background
          onSurface: Color(0xFF333333), // Text on surfaces
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF5E1), // Cream/Beige
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B4513), // Fixed app bar color
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF333333)), // Dark Charcoal
          bodyMedium: TextStyle(color: Color(0xFFD3D3D3)), // Light Gray
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFFFFA500), // Orange
          textTheme: ButtonTextTheme.primary,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFD700), // Yellow
        ),
      ),
      home: AuthGate(),
      routes: {
        '/Auth': (context) => AuthGate(),
        '/homepage': (context) => HomePage(),
        '/addRecipe': (context) => AddRecipePage(),
        '/recipeDetail': (context) => RecipeDetailPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
