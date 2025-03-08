import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/models/analytic_model.dart';

class AddAnalyticDataPage extends StatefulWidget {
  final AnalyticModel analyticModel;
  AddAnalyticDataPage({
    super.key,
    required this.analyticModel,
  });

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sugarLevelController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  State<AddAnalyticDataPage> createState() => _AddAnalyticDataPageState();
}

class _AddAnalyticDataPageState extends State<AddAnalyticDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Monitor your health",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/user_stast.png",
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Track Your ${widget.analyticModel.name} data",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    "Keeping track of your ${widget.analyticModel.name} levels is essential for understanding your health trends",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: mainPurpleColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
