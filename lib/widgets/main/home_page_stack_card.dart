import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';

class HomePageStackCard extends StatelessWidget {
  const HomePageStackCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            "assets/images/frame-medical-equipment-desk.jpg",
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.3),
            // color: Colors.white.withOpacity(0.2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "HeathCare",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                "fill your details",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: subLandMarksCardBg,
                ),
                child: Text(
                  "Click here",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Container(
        //   height: 100,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     color: subLandMarksCardBg,
        //   ),
        // ),
      ],
    );
  }
}
