import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/widgets/reusable/custom_input.dart';

class AlertContainer extends StatelessWidget {
  AlertContainer({super.key});

  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Analytic category name",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 19,
                  color: mainPurpleColor,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              CustomInput(
                controller: _nameController,
                labelText: "Name",
                icon: Icons.category,
                obsecureText: false,
              ),
              SizedBox(
                height: 8,
              ),
              TextButton.icon(
                onPressed: () {},
                label: Text(
                  "Create",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                icon: Icon(
                  Icons.create,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
