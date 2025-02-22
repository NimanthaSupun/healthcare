import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class DarkLightCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  const DarkLightCard({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: subLandMarksCardBg,
          border: Border.all(
            color: Colors.black54,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              ClipRRect(
                child: Image.asset(
                  imageUrl,
                  width: 50,
                  height: 50,
                ),
              ),
              SizedBox(
                width: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
