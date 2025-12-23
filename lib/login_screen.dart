import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;

  void _attemptLogin(){
    String pswd = _passwordController.text;
    setState(() {
      if(pswd.isEmpty){
        _errorMessage = "Password cannot be empty.";
      } else if (pswd == "1234") {
        _errorMessage = null;
        print("Login successful");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!'))
        );
      } else {
        _errorMessage = "Incorrect password. Try again.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black, // Ya viene del tema oscuro en main.dart
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_person, size: 80, color: Colors.greenAccent),
              const SizedBox(height: 20),
              const Text(
                "ACCESO AL BÚNKER",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              
              // CAMPO DE TEXTO
              TextField(
                controller: _passwordController,
                obscureText: true, // Para que salgan puntitos ••••
                decoration: InputDecoration(
                  labelText: "Contraseña Maestra",
                  errorText: _errorMessage, // Muestra el error si no es null
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.key),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // BOTÓN DE ACCESO
              SizedBox(
                width: double.infinity, // Ocupar todo el ancho posible
                height: 50,
                child: ElevatedButton(
                  onPressed: _attemptLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("DESBLOQUEAR"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}