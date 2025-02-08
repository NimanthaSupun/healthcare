import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class SingleClinicCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  const SingleClinicCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      margin: EdgeInsets.only(
        bottom: 15,
      ),
      decoration: BoxDecoration(
        color: subLandMarksCardBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: mainNightLifeColor,
              ),
              SizedBox(
                width: 25,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: mainLandMarksColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Divider(
            color: subLandMarksColor.withOpacity(0.2),
          ),
          SizedBox(height: 3),
          Text(
            description,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
