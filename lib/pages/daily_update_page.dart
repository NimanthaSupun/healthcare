import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/constants/colors.dart';

class DailyUpdatePage extends StatefulWidget {
  const DailyUpdatePage({super.key});

  @override
  State<DailyUpdatePage> createState() => _DailyUpdatePageState();
}

class _DailyUpdatePageState extends State<DailyUpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).go("/");
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          "monitor your health",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 23,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/user_stast.png",
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Track Your Blood Sugar Levels",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Center(
                  child: Text(
                    "Keeping track of your blood sugar levels is essential for understanding your health trends",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                      color: mainGreenColor,
                    ),
                    textAlign: TextAlign.center,
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
