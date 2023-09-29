import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globoapp/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:globoapp/firebase_options.dart';
import 'package:globoapp/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const GloboApp());
}

class GloboApp extends StatelessWidget {
  const GloboApp({super.key});

  Stream<User?> _getCurrentUser() {
    final auth = FirebaseAuth.instance;
    return auth.userChanges();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.dark,
        home: StreamBuilder(
          stream: _getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.data == null) return const LoginScreen();
            return const HomeScreen();
          },
        ),
      ),
    );
  }
}
