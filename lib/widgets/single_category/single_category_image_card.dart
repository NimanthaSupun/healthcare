import 'dart:io';
import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class SingleCategoryImageCard extends StatefulWidget {
  final String title;
  XFile? selectedImage;
  final VoidCallback onPressed;
  SingleCategoryImageCard({
    super.key,
    required this.title,
    this.selectedImage,
    required this.onPressed,
  });

  @override
  State<SingleCategoryImageCard> createState() =>
      _SingleCategoryImageCardState();
}

class _SingleCategoryImageCardState extends State<SingleCategoryImageCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // ignore: deprecated_member_use
        color: blueColor.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                widget.selectedImage != null
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          // ignore: deprecated_member_use
                          color: subLandMarksCardBg.withOpacity(0.9),
                        ),
                        child: IconButton(
                          onPressed: widget.onPressed,
                          icon: Icon(
                            Icons.add_a_photo,
                            size: 20,
                          ),
                        ),
                      )
                    : Text(""),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            SizedBox(
              height: 5,
            ),
            widget.selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(
                        widget.selectedImage!.path,
                      ),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      // ignore: deprecated_member_use
                      color: subLandMarksCardBg.withOpacity(0.9),
                    ),
                    child: IconButton(
                      onPressed: widget.onPressed,
                      icon: Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
