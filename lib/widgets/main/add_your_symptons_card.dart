import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class AddYourSymptonsCard extends StatelessWidget {
  final VoidCallback onPresed;
  const AddYourSymptonsCard({
    super.key,
    required this.onPresed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        elevation: 4,
        shadowColor: Colors.blueGrey,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 165,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // ignore: deprecated_member_use
                color: subLandMarksCardBg.withOpacity(0.9),
                border: Border.all(
                  color: Colors.black54,
                ),
              ),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/images/frame-medical-equipment-desk.jpg",
                  // "assets/images/home-image.jpg",
                  fit: BoxFit.cover,
                  height: 165,
                  width: double.infinity,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 165,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // ignore: deprecated_member_use
                color: subLandMarksCardBg.withOpacity(0.25),
                // border: Border.all(
                //   color: Colors.black54,
                // ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Center(
                            child: Text(
                              "Personalize",
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Your Categories",
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: onPresed,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 3,
                          shadowColor: mainBlueColor,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: mainWhiteColor,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 27,
                            ),
                          ),
                        ),
                      ),
                    ],
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
