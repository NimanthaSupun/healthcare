import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/sympton_model.dart';
import 'package:healthcare/widgets/reusable/custom_button.dart';
import 'package:healthcare/widgets/reusable/custom_input.dart';
import 'package:healthcare/widgets/single_category/single_category_image_card.dart';
import 'package:image_picker/image_picker.dart';

class UpdateSymptonPage extends StatefulWidget {
  final SymptonModel symptonModel;
  const UpdateSymptonPage({
    super.key,
    required this.symptonModel,
  });

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
  void initState() {
    super.initState();
  }


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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Upload Your symptom Records",
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
                          labelText: "symptoms Name",
                          icon: Icons.description,
                          obsecureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please enter symptoms name";
                            }
                            return null;
                          },
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
                          onPressed: () =>
                              _pickedDoctorNote(ImageSource.gallery),
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
                          onPressed: () =>
                              _pickedClinicNote(ImageSource.gallery),
                          selectedImage: _selectedClinicNoteImage,
                        ),
                        SizedBox(height: 15),
                        _isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : CustomButton(
                                title: "Upload",
                                width: double.infinity,
                                onPressed: () => _submitSympton(context),
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
      ),
    );
  }

  Future<void> _pickedMedicalReport(ImageSource gallery) async {
    final XFile? image =
        await medicalImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedmedicalReportImage = image;
      _medicalReportImage = File(image!.path);
      _base64MedicalReportImage =
          base64Encode(_medicalReportImage!.readAsBytesSync());
    });
  }

  Future<void> _pickedDoctorNote(ImageSource gallery) async {
    final XFile? image =
        await doctorImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedDoctorNoteImage = image;
      _doctorNoteImage = File(image!.path);
      _base64DoctorNoteImage =
          base64Encode(_doctorNoteImage!.readAsBytesSync());
    });
  }

  Future<void> _pickedPrescription(ImageSource gallery) async {
    final XFile? image =
        await prescriptionImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedPrescriptionImage = image;
      _prescriptionImage = File(image!.path);
      _base64PrescriptionImage =
          base64Encode(_prescriptionImage!.readAsBytesSync());
    });
  }

  Future<void> _pickedClinicNote(ImageSource gallery) async {
    final XFile? image =
        await clinicImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedClinicNoteImage = image;
      _clinicNoteImage = File(image!.path);
      _base64ClinicNoteImage =
          base64Encode(_clinicNoteImage!.readAsBytesSync());
    });
  }
}
