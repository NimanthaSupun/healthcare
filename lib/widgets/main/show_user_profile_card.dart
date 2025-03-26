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
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // ignore: deprecated_member_use
          // color: subLandMarksCardBg.withOpacity(0.5),
          color: mainWhiteColor,
          border: Border.all(
            color: Colors.black54,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              child: Image.asset(
                "assets/images/man_4140048.png",
                width: 50,
                height: 50,
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
