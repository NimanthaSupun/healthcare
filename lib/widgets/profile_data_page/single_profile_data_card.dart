import 'package:flutter/material.dart';
// import 'package:healthcare/constants/colors.dart';

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
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: 45,
                height: 45,
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
      ),
    );
  }
}
