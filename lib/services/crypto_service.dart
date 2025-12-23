import 'package:encrypt/encrypt.dart' as enc;

class CryptoService {
  /// Generates a random 256-bit AES key.
  static enc.Key generateRandomKey() {
    return enc.Key.fromSecureRandom(32); // 256 bits (AES-256)
  }

  /// Encrypts the given plain text using AES encryption with the provided key.
  static String encrypt(String plainText, enc.Key k) {
    final iv = enc.IV.fromSecureRandom(16); // AES block size is 16 bytes
    final encrypter = enc.Encrypter(enc.AES(k));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return "${iv.base64}:${encrypted.base64}";
  }

  /// Decrypts the given encrypted text using AES decryption with the provided key.
  static String decrypt(String encryptedText, enc.Key k) {
    try {
      final parts = encryptedText.split(':');
      final iv = enc.IV.fromBase64(parts[0]);
      final encryptedTextBase64 = parts[1];

      final encrypter = enc.Encrypter(enc.AES(k));

      final encrypted = enc.Encrypted.fromBase64(encryptedTextBase64);
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      return "Error: Decryption failed. Invalid data or key.";
    }
  }
}