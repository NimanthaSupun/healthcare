import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class ShowUserProfileCard extends StatelessWidget {
  final VoidCallback onPresed;
  const ShowUserProfileCard({
    super.key,
    required this.onPresed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: subLandMarksCardBg.withOpacity(0.9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              child: Image.asset(
                "assets/images/user_profile_icon.png",
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              "Show Your profile data",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            IconButton(
              onPressed: onPresed,
              icon: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}
