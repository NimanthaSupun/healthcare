import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class CreateAnalyticCategory extends StatelessWidget {
  final VoidCallback onPressed;
  const CreateAnalyticCategory({
    super.key,
    required this.onPressed,
  });

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
            ClipRect(
              child: Image.asset(
                "assets/images/menu_15604342.png",
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              "Create analytic category",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.add,
                size: 30,
                color: mainPurpleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
