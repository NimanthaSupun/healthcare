import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obsecureText;
  final String? Function(String?)? validator;
  final String? hintText;
  final TextInputType? keyboardType;

  const CustomInput({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.obsecureText,
    this.validator,
    this.hintText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obsecureText,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        prefixIcon: Icon(
          icon,
          size: 20,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 2,
            )),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 1,
          ),
        ),
      ),
    );
  }
}
