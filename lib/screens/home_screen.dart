import 'package:flutter/material.dart';
import 'package:bunker/services/database_helper.dart';
import 'package:bunker/models/password_item.dart';
import '../widgets/password_card.dart';
import 'add_password_screen.dart';

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
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPasswordScreen()),
          );

          if (result == true) {
            // Refresh the list if a new password was added
            refreshPasswords();
          }
        },
      ),
    );
  }

  /// Builds the UI for the empty state when no passwords are stored
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const[
          Icon(Icons.lock_outline, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'The vault is empty',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      )
    );
  }

  /// Builds the list view of stored passwords
  Widget _buildPasswordList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: passwords.length,
      itemBuilder: (context, index) {
        final item = passwords[index];
        
        // Use the PasswordCard widget
        return PasswordCard(
          item: item,
          
          // What to do on tap (EDIT)
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPasswordScreen(itemToEdit: item),
              ),
            );
            if (result == true) refreshPasswords();
          },
          
          // What to do on delete (SHOW DIALOG)
          onDelete: () {
            showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: const Text('Delete secret?'),
                  content: Text('You are about to delete the password for "${item.title}". This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(ctx).pop(); // Close alert
                        if (item.id != null) {
                          await DatabaseHelper.instance.delete(item.id!);
                          refreshPasswords(); // Refresh list
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Deleted successfully')),
                            );
                          }
                        }
                      },
                      child: const Text('DELETE', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}