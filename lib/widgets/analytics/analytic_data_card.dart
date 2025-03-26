import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/pages/analytics/show_analytic_data_page.dart';

class AnalyticDataCard extends StatelessWidget {
  const AnalyticDataCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: mobileBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              child: Image.asset(
                "assets/images/analytic-chart_3954775.png",
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
            Text(
              "View All Vital Data",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            SizedBox(
              width: 2,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShowAnalyticDataPage(),
                  ),
                );
              },
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 30,
                color: mainLandMarksColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
