import 'package:flutter/material.dart';
import 'package:bunker/services/database_helper.dart';
import 'package:bunker/models/password_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PasswordItem> passwords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refreshPasswords();
  }

  /// Refreshes the list of passwords from the database
  Future<void> refreshPasswords() async {
    setState(() => isLoading = true);
    final data = await DatabaseHelper.instance.readAllPasswords();
    setState(() {
      passwords = data.map((item) => PasswordItem.fromMap(item)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bunker Vault'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.blueGrey[50],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : passwords.isEmpty
              ? _buildEmptyState()
              : _buildPasswordList(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[900],
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Navigate to add password screen (to be implemented)
        },
      ),
    );
  }
}