import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class SingleProfileDataCard extends StatelessWidget {
  final String title;
  final String userData;
  final String imageUrl;
  const SingleProfileDataCard({
    super.key,
    required this.title,
    required this.userData,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: subLandMarksCardBg.withOpacity(0.9),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              userData,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
