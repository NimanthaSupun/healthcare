import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class AnalyticDataCard extends StatelessWidget {
  const AnalyticDataCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: mobileBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 5,
        ),
        child: Row(
          children: [
            ClipRRect(
              child: Image.asset(
                "assets/images/analytic-chart_3954775.png",
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
