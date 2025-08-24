import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/user_service.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  try {
    await UserService.initialize();
    print('Supabase initialized successfully');
  } catch (e) {
    print('Failed to initialize Supabase: $e');
  }

  // Initialize Auth Service
  try {
    await AuthService.initialize();
    print('Auth Service initialized successfully');
  } catch (e) {
    print('Failed to initialize Auth Service: $e');
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NABARD MRV Platform',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
