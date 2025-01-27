import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/models/user_model.dart';
import 'package:healthcare/widgets/profile_data_page/single_profile_data_card.dart';

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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Personalize Fitness and Health",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "This information ensures Fitnes and Health data are as accurate as possible",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                SingleProfileDataCard(
                  title: "Name",
                  userData: user.name,
                  imageUrl: "assets/images/card_16581871.png",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
