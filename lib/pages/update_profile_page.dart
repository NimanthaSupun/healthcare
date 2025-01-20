import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/models/user_model.dart';

class UpdateProfilePage extends StatefulWidget {
  final UserModel user;
  const UpdateProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).go('/');
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}
