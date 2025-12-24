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
}