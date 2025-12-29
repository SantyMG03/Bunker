import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/password_item.dart';

class AddPasswordScreen extends StatefulWidget {
  const AddPasswordScreen({super.key});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free resources
    _titleController.dispose();
    _userController.dispose();
    _passController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _savePassword() async {
    if (_formKey.currentState!.validate()) {
      final newItem = PasswordItem(
        title: _titleController.text,
        username: _userController.text,
        encryptedPswd: _passController.text, 
        notes: _notesController.text,
        createdAt: DateTime.now(),
      );

      await DatabaseHelper.instance.create(newItem.toMap());

      if (mounted) {
        Navigator.pop(context, true); // Indicate that a new item was added

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password saved successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Password'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Sitio Web / Título',
                  prefixIcon: Icon(Icons.language),
                  border: OutlineInputBorder(),
                  hintText: 'E.g. Netflix, Gmail, Bank...',
                ),
                validator: (value) => value!.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),

              // Username Field
              TextFormField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: 'User / Email',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Username is required' : null,
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passController,
                obscureText: false, // Set to true if you want to hide the password while typing
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Password is required' : null,
              ),
              const SizedBox(height: 16),

              // Notes Field
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _savePassword,
                  icon: const Icon(Icons.save),
                  label: const Text('SAVE TO VAULT'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}