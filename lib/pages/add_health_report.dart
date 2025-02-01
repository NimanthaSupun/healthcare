import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthcare/widgets/reusable/custom_button.dart';
import 'package:healthcare/widgets/reusable/custom_input.dart';
import 'package:healthcare/widgets/single_category/single_category_image_card.dart';
import 'package:image_picker/image_picker.dart';

class AddHealthReport extends StatefulWidget {
  const AddHealthReport({super.key});

  @override
  State<AddHealthReport> createState() => _AddHealthReportState();
}

class _AddHealthReportState extends State<AddHealthReport> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _symptonsController = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
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

  // Future<void> _pickedImage(ImageSource gallery) async {
  //   final XFile? image =
  //       await imagePicker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     _selectedmedicalReportImage = image;
  //     _selectedDoctorNoteImage = image;
  //     _selectedPrescriptionImage = image;
  //     _selectedClinicNoteImage = image;

  //     _image = File(image!.path);
  //     _base64Image = base64Encode(_image!.readAsBytesSync());
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  "Upload Your Health Record",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      CustomInput(
                        controller: _symptonsController,
                        labelText: "add your symptoms",
                        icon: Icons.description,
                        obsecureText: false,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      SingleCategoryImageCard(
                        title: "Medical reports",
                        onPressed: () =>
                            _pickedMedicalReport(ImageSource.gallery),
                        selectedImage: _selectedmedicalReportImage,
                      ),
                      SizedBox(height: 15),
                      SingleCategoryImageCard(
                        title: "Doctor note",
                        onPressed: () => _pickedDoctorNote(ImageSource.gallery),
                        selectedImage: _selectedDoctorNoteImage,
                      ),
                      SizedBox(height: 15),
                      SingleCategoryImageCard(
                        title: "Prescription",
                        onPressed: () =>
                            _pickedPrescription(ImageSource.gallery),
                        selectedImage: _selectedPrescriptionImage,
                      ),
                      SizedBox(height: 15),
                      SingleCategoryImageCard(
                        title: "Clinic note",
                        onPressed: () => _pickedClinicNote(ImageSource.gallery),
                        selectedImage: _selectedClinicNoteImage,
                      ),
                      SizedBox(height: 15),
                      CustomButton(
                        title: "Upload",
                        width: double.infinity,
                        onPressed: () {},
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickedMedicalReport(ImageSource gallery) async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedmedicalReportImage = image;
      _medicalReportImage = File(image!.path);
      _base64DoctorNoteImage =
          base64Encode(_medicalReportImage!.readAsBytesSync());
    });
  }

  Future<void> _pickedDoctorNote(ImageSource gallery) async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedDoctorNoteImage = image;
      _doctorNoteImage = File(image!.path);
      _base64DoctorNoteImage =
          base64Encode(_doctorNoteImage!.readAsBytesSync());
    });
  }

  Future<void> _pickedPrescription(ImageSource gallery) async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedPrescriptionImage = image;
      _prescriptionImage = File(image!.path);
      _base64PrescriptionImage =
          base64Encode(_prescriptionImage!.readAsBytesSync());
    });
  }

  Future<void> _pickedClinicNote(ImageSource gallery) async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedClinicNoteImage = image;
      _clinicNoteImage = File(image!.path);
      _base64ClinicNoteImage =
          base64Encode(_clinicNoteImage!.readAsBytesSync());
    });
  }
}
