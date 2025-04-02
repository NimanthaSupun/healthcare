import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class SingleNavigateCard extends StatelessWidget {
  final String title;
  final String iconUrl;
  final VoidCallback onPressed;
  const SingleNavigateCard({
    super.key,
    required this.title,
    required this.iconUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: subLandMarksCardBg.withOpacity(0.00001),

        // color: mainWhiteColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black54,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          ClipRect(
            child: Image.asset(
              iconUrl,
              fit: BoxFit.cover,
              width: 45,
              height: 45,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
