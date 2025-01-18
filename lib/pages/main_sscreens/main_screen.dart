import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/user_model.dart';
import 'package:healthcare/services/auth/auth_service.dart';
import 'package:healthcare/services/users/user_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final currentUser = AuthService().getCurrentUser()!.uid;

  late Future<UserModel?> _userFuture;
  late String _currentUserId;
  late UserService _userService;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _userFuture = _fetchUserDetails();
  }

  Future<UserModel?> _fetchUserDetails() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final user = await _userService.getUserById(userId);
      return user;
    } catch (error) {
      print("Error fetching user details: $error");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Text(currentUser),
          ),
          FutureBuilder<UserModel?>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Text("No user data found.");
              }

              final user = snapshot.data!;

              // Assuming `user.base64Image` is the field where the Base64 image string is stored
              if (user.base64Image == null || user.base64Image!.isEmpty) {
                return const Text("No image available.");
              }

              try {
                final decodedBytes = base64Decode(user.base64Image!);

                return Column(
                  children: [
                    Image.memory(decodedBytes, width: 200, height: 200),
                  ],
                );
              } catch (e) {
                return const Text("Error decoding image.");
              }
            },
          ),
        ],
      ),
    );
  }
}
