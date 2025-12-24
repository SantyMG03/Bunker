class PasswordItem {
  final int? id;
  final String title;
  final String username;
  final String encryptedPswd;
  final String notes;
  final DateTime createdAt;

  PasswordItem({
    this.id,
    required this.title,
    required this.username,
    required this.encryptedPswd,
    this.notes = '',
    required this.createdAt,
  });

  /// Converts a PasswordItem instance to a Map (JSON) for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'user_name': username,
      'encrypted_pswd': encryptedPswd,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(), // DateTime saved as a String
    };
  }

  /// Converts a Map (JSON) from the database back to a PasswordItem instance.
  factory PasswordItem.fromMap(Map<String, dynamic> map) {
    return PasswordItem(
      id: map['id'] as int?,
      title: map['title'] as String,
      username: map['user_name'] as String,
      encryptedPswd: map['encrypted_pswd'] as String,
      notes: map['notes'] as String? ?? '', // Default to empty string if null
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  /// Creates a copy of the current PasswordItem with optional new values.
  PasswordItem copyWith({
    int? id,
    String? title,
    String? username,
    String? encryptedPswd,
    String? notes,
    DateTime? createdAt,
  }) {
    return PasswordItem(
      id: id ?? this.id,
      title: title ?? this.title,
      username: username ?? this.username,
      encryptedPswd: encryptedPswd ?? this.encryptedPswd,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}