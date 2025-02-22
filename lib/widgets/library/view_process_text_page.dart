import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class ViewProcessTextPage extends StatelessWidget {
  final String title;
  final String processText;
  const ViewProcessTextPage({
    super.key,
    required this.title,
    required this.processText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: subLandMarksCardBg),
                  child: Column(
                    children: [
                      Text(
                        processText,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
