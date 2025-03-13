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
          horizontal: 10,
        ),
        child: Row(
          children: [
            ClipRRect(
              child: Image.asset(
                "assets/images/analytic-chart_3954775.png",
                fit: BoxFit.cover,
                height: 60,
                width: 60,
              ),
            ),
            Text(
              "View All Analytic Data",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
