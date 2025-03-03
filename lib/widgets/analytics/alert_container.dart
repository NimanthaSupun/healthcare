import 'package:flutter/material.dart';

class AlertContainer extends StatelessWidget {
  const AlertContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    "Enter category name",
                  ),

                ],
              ),
            );
  }
}