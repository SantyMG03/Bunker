import 'package:flutter/material.dart';
import 'dart:math';
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

  void _generatePassword() {
    const length = 16;
    const letters = 'abcdefghijklmnopqrstuvwxyz';
    const uppers = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const specials = '@#%^*&!_';

    const allChars = letters + uppers + numbers + specials;
    final random = Random();

    // Ensure the password contains at least one character from each category
    List<String> passwordChars =[
      letters[random.nextInt(letters.length)],
      uppers[random.nextInt(uppers.length)],
      numbers[random.nextInt(numbers.length)],
      specials[random.nextInt(specials.length)],
    ];

    // Fill the rest of the password length with random characters from all categories
    for (int i = 4; i < length; i++) {
      passwordChars.add(allChars[random.nextInt(allChars.length)]);
    }

    passwordChars.shuffle();

    setState(() {
      _passController.text = passwordChars.join();
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password generated!'),
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 1),
      ),
    );
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
              
              // Password field with generate button
              TextFormField(
                controller: _passController,
                obscureText: false, 
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.vpn_key),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.greenAccent),
                    tooltip: "Generate secure password",
                    onPressed: _generatePassword,
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Password is required' : null,
              ),
              // Hint text for password generation
              const Padding(
                padding: EdgeInsets.only(top: 5, left: 10),
                child: Text(
                  "Press the lightning ⚡ to generate a secure password",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
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