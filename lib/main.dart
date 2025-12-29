import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; 
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ElBunkerApp());
}

class ElBunkerApp extends StatelessWidget {
  const ElBunkerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Bunker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        colorScheme: const ColorScheme.dark(primary: Colors.greenAccent),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.greenAccent,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BUNKER ACCESO'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_outlined, size: 100, color: Colors.greenAccent),
            const SizedBox(height: 20),
            const Text('Sistema Seguro Offline', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
              icon: const Icon(Icons.fingerprint),
              label: const Text("INGRESAR A LA BÓVEDA"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}