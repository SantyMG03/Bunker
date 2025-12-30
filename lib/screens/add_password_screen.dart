import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/password_item.dart';

class AddPasswordScreen extends StatefulWidget {
  // Optional parameter to edit an existing password
  final PasswordItem? itemToEdit;

  const AddPasswordScreen({super.key, this.itemToEdit});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _userController;
  late TextEditingController _passController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.itemToEdit?.title ?? '');
    _userController = TextEditingController(text: widget.itemToEdit?.username ?? '');
    _passController = TextEditingController(text: widget.itemToEdit?.encryptedPswd ?? '');
    _notesController = TextEditingController(text: widget.itemToEdit?.notes ?? '');
  }

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
        id: widget.itemToEdit?.id,
        title: _titleController.text,
        username: _userController.text,
        encryptedPswd: _passController.text, 
        notes: _notesController.text,
        createdAt: widget.itemToEdit?.createdAt ?? DateTime.now(),
      );

      // Decide whether to create a new entry or update an existing one
      if (widget.itemToEdit != null) {
        await DatabaseHelper.instance.update(newItem.toMap());
      } else {
        await DatabaseHelper.instance.create(newItem.toMap());
      }

      if (mounted) {
        Navigator.pop(context, true); // Indicate that a new item was added

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.itemToEdit != null 
            ? 'Password updated!' 
            : 'Password saved!'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cambiamos el título de la pantalla según el modo
    final isEditing = widget.itemToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Secret' : 'New Secret'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Website / Title',
                  prefixIcon: Icon(Icons.language),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: 'User / Email',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'User is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Password is required' : null,
              ),
              const SizedBox(height: 16),
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
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _savePassword,
                  icon: const Icon(Icons.save),
                  label: Text(isEditing ? 'UPDATE DATA' : 'SAVE TO VAULT'),
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