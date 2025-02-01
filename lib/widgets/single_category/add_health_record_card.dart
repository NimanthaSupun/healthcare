import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class AddHealthRecordCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  const AddHealthRecordCard(
      {super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 250,
      decoration: BoxDecoration(
        color: subLandMarksCardBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            width: 120,
            height: 120,
          ),
        ],
      ),
    );
  }
}
