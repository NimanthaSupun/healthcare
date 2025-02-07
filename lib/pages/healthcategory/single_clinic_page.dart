import 'package:flutter/material.dart';
import 'package:healthcare/models/clinic_model.dart';

class SingleClinicPage extends StatelessWidget {
  final Clinic clinic;
  const SingleClinicPage({
    super.key,
    required this.clinic,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
