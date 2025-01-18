import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final double width;
  final VoidCallback onPressed;
  const CustomButton({
    super.key,
    required this.title,
    required this.width,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        gradient: gradientColor1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: mainWhiteColor,
          ),
        ),
      ),
    );
  }
}
