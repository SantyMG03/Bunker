import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const ElBunkerApp());
}

class ElBunkerApp extends StatelessWidget {
  const ElBunkerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Búnker',
      // Quitamos la etiqueta de "Debug" de la esquina
      debugShowCheckedModeBanner: false,
      // Tema oscuro puro (estilo hacker/seguridad)
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A), // Gris muy oscuro
        colorScheme: const ColorScheme.dark(
          primary: Colors.greenAccent, // Color de acento estilo terminal
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
      appBar: AppBar(
        title: const Text('BUNKER'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono de candado gigante
            const Icon(
              Icons.shield_outlined,
              size: 100,
              color: Colors.greenAccent
            ),
            const SizedBox(height: 20),
            const Text(
              'Sistema Seguro Offline',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Esperando acceso...',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            // Un botón de prueba
            ElevatedButton.icon(
              onPressed: () {
                print("Botón pulsado");
              },
              icon: const Icon(Icons.fingerprint),
              label: const Text("INGRESAR"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black, // Color del texto del botón
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}