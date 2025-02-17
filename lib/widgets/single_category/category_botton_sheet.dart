import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class CategoryBottonSheet extends StatelessWidget {
  final VoidCallback deleteCallback;
  final VoidCallback editCallback;
  final String title1;
  final String title2;
  const CategoryBottonSheet({
    super.key,
    required this.deleteCallback,
    required this.editCallback,
    required this.title1,
    required this.title2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: subLandMarksCardBg,
                border: Border.all(
                  color: mainOrangeColor,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    title1,
                    style: TextStyle(
                      fontSize: 18,
                      color: mainOrangeColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    onPressed: deleteCallback,
                    icon: Icon(
                      Icons.delete,
                      size: 25,
                      color: mainOrangeColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: subLandMarksCardBg,
                border: Border.all(
                  color: mainLandMarksColor,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    title2,
                    style: TextStyle(
                      fontSize: 18,
                      color: mainLandMarksColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    onPressed: editCallback,
                    icon: Icon(
                      Icons.edit,
                      size: 25,
                      color: mainLandMarksColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
