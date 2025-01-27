import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/models/user_model.dart';

class ProfileDataPage extends StatelessWidget {
  final UserModel user;
  const ProfileDataPage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(user.name),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).go("/");
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              
            ],
          ),
        ),
      ),
    );
  }
}
