import 'dart:io';
import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class SingleCategoryImageCard extends StatefulWidget {
  final String title;
  XFile? selectedImage;
  final VoidCallback onPressed;
  final VoidCallback processImage;
  final bool isRecognized;
  String recognizedText;

  SingleCategoryImageCard({
    super.key,
    required this.title,
    this.selectedImage,
    required this.onPressed,
    required this.processImage,
    required this.recognizedText,
    required this.isRecognized,
  });

  @override
  State<SingleCategoryImageCard> createState() =>
      _SingleCategoryImageCardState();
}

class _SingleCategoryImageCardState extends State<SingleCategoryImageCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: mobileBackgroundColor,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // ignore: deprecated_member_use
          color: subLandMarksCardBg.withOpacity(0.5),
          // border: Border.all(
          //   color: Colors.black54,
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainLandMarksColor,
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
                      : SizedBox(),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(),
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                children: [
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
                ],
              ),
              SizedBox(
                height: 10,
              ),
              widget.recognizedText.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.recognizedText = "";
                        });
                      },
                      child: Container(
                        width: 200,
                        height: 35,
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: mainWhiteColor,
                          border: Border.all(
                            color: mainOrangeColor,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Clear this",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: mainOrangeColor,
                              ),
                            ),
                            Icon(
                              Icons.clear,
                              size: 28,
                              color: mainOrangeColor,
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 10,
                    ),
              widget.recognizedText.isNotEmpty
                  ? Scrollbar(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: mainPurpleColor,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: mainWhiteColor,
                            ),
                            child: SelectableText(
                              cursorColor: mainOrangeColor,
                              widget.recognizedText.isEmpty
                                  ? "No text process"
                                  : widget.recognizedText,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 1,
              ),
              if (widget.selectedImage != null) ...[
                Column(
                  children: [
                    GestureDetector(
                      onTap: widget.processImage,
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: mainWhiteColor,
                          border: Border.all(
                            color: mainNightLifeColor,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Process Image",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: mainPurpleColor,
                              ),
                            ),
                            widget.isRecognized
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.orange,
                                    ),
                                  )
                                : Icon(
                                    Icons.auto_awesome,
                                    size: 30,
                                    color: mainPurpleColor,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
