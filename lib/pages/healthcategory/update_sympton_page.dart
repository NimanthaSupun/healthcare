import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/sympton_model.dart';
import 'package:image_picker/image_picker.dart';

class UpdateSymptonPage extends StatefulWidget {
  const UpdateSymptonPage({super.key});

  @override
  State<UpdateSymptonPage> createState() => _UpdateSymptonPageState();
}

class _UpdateSymptonPageState extends State<UpdateSymptonPage> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _symptonsController = TextEditingController();

  final ImagePicker medicalImagePicker = ImagePicker();
  final ImagePicker doctorImagePicker = ImagePicker();
  final ImagePicker prescriptionImagePicker = ImagePicker();
  final ImagePicker clinicImagePicker = ImagePicker();

  @override
  void dispose() {
    _symptonsController.dispose();
    super.dispose();
  }

  XFile? _selectedmedicalReportImage;
  XFile? _selectedDoctorNoteImage;
  XFile? _selectedPrescriptionImage;
  XFile? _selectedClinicNoteImage;

  String? _base64MedicalReportImage;
  String? _base64DoctorNoteImage;
  String? _base64PrescriptionImage;
  String? _base64ClinicNoteImage;

  File? _medicalReportImage;
  File? _doctorNoteImage;
  File? _prescriptionImage;
  File? _clinicNoteImage;

  bool _isLoading = false;

  void _submitSympton(BuildContext context) async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      setState(() {
        _isLoading = true;
      });

      final SymptonModel symptonModel = SymptonModel(
        id: "",
        name: _symptonsController.text,
        medicalReportImage: _base64MedicalReportImage,
        doctorNoteImage: _base64DoctorNoteImage,
        precriptionsImage: _base64PrescriptionImage,
        clinicNoteImage: _base64ClinicNoteImage,
      );

     

      UtilFunctions().showSnackBarWdget(
        // ignore: use_build_context_synchronously
        context,
        "Your sympton record has been created!",
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (error) {
      print("Error: ${error}");
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("$error"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("ok"),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}