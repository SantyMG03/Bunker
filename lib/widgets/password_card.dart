import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/password_item.dart';

class PasswordCard extends StatefulWidget {
  final PasswordItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PasswordCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<PasswordCard> createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard> {
  bool _isObscured = true; // By default, password is obscured

  /// Auxiliary method to copy password to clipboard
  void _copyToClipboard(BuildContext context, String text, String type) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type copied to clipboard'),
        backgroundColor: Colors.greenAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // Left side icon: A key icon inside a circle avatar
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey[800],
          child: const Icon(Icons.vpn_key, color: Colors.greenAccent),
        ),

        // Title and User
        title: Text (
          widget.item.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.item.username, style: TextStyle(color: Colors.grey[400])),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  _isObscured ? Icons.lock_outline : Icons.lock_open,
                  size: 14,
                  color: _isObscured ? Colors.grey : Colors.greenAccent,
                ),
                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    _isObscured ? '••••••••••••' : widget.item.encryptedPswd,
                    style: TextStyle(
                      fontFamily: 'Courier',
                      color: _isObscured ? Colors.grey : Colors.white,
                      fontWeight: _isObscured ? FontWeight.normal : FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  )
                )
              ],
            )
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility : Icons.visibility_off,
                color: Colors.blueGrey,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: widget.onDelete,
            ),
          ],
        ),
        onTap: widget.onTap,
      ),
    );
  }
}