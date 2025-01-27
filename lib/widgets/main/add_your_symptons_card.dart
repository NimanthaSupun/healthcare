import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class AddYourSymptonsCard extends StatelessWidget {
  const AddYourSymptonsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: subLandMarksCardBg.withOpacity(0.3),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                // "assets/images/undraw_track-and-field_i2au.png",
                "assets/images/close-up-hands-holding-stethoscope.jpg",
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: subLandMarksCardBg.withOpacity(0.5),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add Your Symptons",
                      style: TextStyle(
                        fontSize: 30,
                        // color: mainWhiteColor.withOpacity(1),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


//  Text(
//                   "Add Your Symptons",
//                   style: TextStyle(
//                     fontSize: 30,
//                     color: mainWhiteColor.withOpacity(1),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),