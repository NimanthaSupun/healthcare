import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/health_category_model.dart';
import 'package:healthcare/models/sympton_model.dart';
import 'package:healthcare/services/category/symton_service.dart';
import 'package:healthcare/widgets/reusable/custom_button.dart';
import 'package:healthcare/widgets/reusable/custom_input.dart';
import 'package:healthcare/widgets/single_category/single_category_image_card.dart';
import 'package:image_picker/image_picker.dart';

class AddHealthReport extends StatefulWidget {
  final HealthCategory healthCategory;

  const AddHealthReport({
    super.key,
    required this.healthCategory,
  });
  @override
  State<AddHealthReport> createState() => _AddHealthReportState();
}

class _AddHealthReportState extends State<AddHealthReport> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _symptonsController = TextEditingController();

  final ImagePicker medicalImagePicker = ImagePicker();
  final ImagePicker doctorImagePicker = ImagePicker();
  final ImagePicker prescriptionImagePicker = ImagePicker();
  final ImagePicker clinicImagePicker = ImagePicker();

  late DateTime _selectedDate;
  late TextRecognizer medicalTextRecognizer;
  late TextRecognizer doctorTextRecognizer;
  late TextRecognizer prescriptionTextRecognizer;
  late TextRecognizer clinicTextRecognizer;

  String medicalRecognizedText = "";
  String doctorRecognizedText = "";
  String prescriptionRecognizedText = "";
  String clinicRecognizedText = "";

  bool isMedicalRecognized = false;
  bool isDoctorRecognized = false;
  bool isPrescriptionRecognized = false;
  bool isClinicRecognized = false;

  String? pickedMedicalImagePath;
  String? pickedDoctorImagePath;
  String? pickedPrescriptionImagePath;
  String? pickedClinicImagePath;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    medicalTextRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    doctorTextRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    prescriptionTextRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    clinicTextRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
  }

  Future<void> _onSelectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
      initialDate: _selectedDate,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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
        dueDate: _selectedDate,
        name: _symptonsController.text,
        medicalReportImage: _base64MedicalReportImage,
        doctorNoteImage: _base64DoctorNoteImage,
        precriptionsImage: _base64PrescriptionImage,
        clinicNoteImage: _base64ClinicNoteImage,
      );

      await SymtonService().addNewSympton(
        FirebaseAuth.instance.currentUser!.uid,
        widget.healthCategory.id,
        symptonModel,
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
            padding: EdgeInsets.all(1),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Upload Your symptom Records",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 5,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Date: ${_selectedDate.toLocal().toString().split(" ")[0]}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _onSelectDate,
                                icon: const Icon(
                                  Icons.calendar_today,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomInput(
                          controller: _symptonsController,
                          labelText: "Note",
                          icon: Icons.description,
                          obsecureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please enter some note's";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SingleCategoryImageCard(
                          title: "Medical reports",
                          onPressed: () =>
                              _pickedMedicalReport(ImageSource.gallery),
                          selectedImage: _selectedmedicalReportImage,
                          processImage: _processMedicalImage,
                          isRecognized: isMedicalRecognized,
                          recognizedText: medicalRecognizedText,
                        ),
                        SizedBox(height: 15),
                        SingleCategoryImageCard(
                          title: "Doctor note",
                          onPressed: () =>
                              _pickedDoctorNote(ImageSource.gallery),
                          selectedImage: _selectedDoctorNoteImage,
                          processImage: _processDoctorImage,
                          isRecognized: isDoctorRecognized,
                          recognizedText: doctorRecognizedText,
                        ),
                        SizedBox(height: 15),
                        SingleCategoryImageCard(
                          title: "Prescription",
                          onPressed: () =>
                              _pickedPrescription(ImageSource.gallery),
                          selectedImage: _selectedPrescriptionImage,
                          processImage: _processPrescriptionImage,
                          isRecognized: isPrescriptionRecognized,
                          recognizedText: prescriptionRecognizedText,
                        ),
                        SizedBox(height: 15),
                        SingleCategoryImageCard(
                          title: "Clinic note",
                          onPressed: () =>
                              _pickedClinicNote(ImageSource.gallery),
                          selectedImage: _selectedClinicNoteImage,
                          processImage: _procesClinicImage,
                          isRecognized: isClinicRecognized,
                          recognizedText: clinicRecognizedText,
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
      pickedMedicalImagePath = image.path;
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
      pickedDoctorImagePath = image.path;
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
      pickedPrescriptionImagePath = image.path;
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
      pickedClinicImagePath = image.path;
    });
  }

  // todo: function to proccess doctoernote image
  void _processDoctorImage() async {
    if (_base64DoctorNoteImage == null) {
      return;
    }
    setState(() {
      isDoctorRecognized = true;
      doctorRecognizedText = "";
    });

    try {
      final inputImage = InputImage.fromFilePath(pickedDoctorImagePath!);
      final RecognizedText recognizedTextFrommodel =
          await doctorTextRecognizer.processImage(inputImage);

      // loop block
      for (TextBlock block in recognizedTextFrommodel.blocks) {
        for (TextLine line in block.lines) {
          doctorRecognizedText += "${line.text} \n";
        }
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
    } finally {
      setState(() {
        isDoctorRecognized = false;
      });
    }
  }

  // todo: function to process medical image
  void _processMedicalImage() async {
    if (_base64MedicalReportImage == null) {
      return;
    }
    setState(() {
      isMedicalRecognized = true;
      medicalRecognizedText = "";
    });

    try {
      final inputImage = InputImage.fromFilePath(pickedMedicalImagePath!);
      final RecognizedText recognizedTextFrommodel =
          await medicalTextRecognizer.processImage(inputImage);

      // loop block
      for (TextBlock block in recognizedTextFrommodel.blocks) {
        for (TextLine line in block.lines) {
          medicalRecognizedText += "${line.text} \n";
        }
      }
      print(medicalRecognizedText);
    } catch (error) {
      if (!mounted) {
        return;
      }
    } finally {
      setState(() {
        isMedicalRecognized = false;
      });
    }
  }

  // todo: function to proccess prescription image
  void _processPrescriptionImage() async {
    if (_base64PrescriptionImage == null) {
      return;
    }
    setState(() {
      isPrescriptionRecognized = true;
      prescriptionRecognizedText = "";
    });

    try {
      final inputImage = InputImage.fromFilePath(pickedPrescriptionImagePath!);
      final RecognizedText recognizedTextFrommodel =
          await prescriptionTextRecognizer.processImage(inputImage);

      // loop block
      for (TextBlock block in recognizedTextFrommodel.blocks) {
        for (TextLine line in block.lines) {
          prescriptionRecognizedText += "${line.text} \n";
        }
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
    } finally {
      setState(() {
        isPrescriptionRecognized = false;
      });
    }
  }

  // todo: function to process clinic image
  void _procesClinicImage() async {
    if (_base64ClinicNoteImage == null) {
      return;
    }
    setState(() {
      isClinicRecognized = true;
      clinicRecognizedText = "";
    });

    try {
      final inputImage = InputImage.fromFilePath(pickedClinicImagePath!);
      final RecognizedText recognizedTextFrommodel =
          await clinicTextRecognizer.processImage(inputImage);

      // loop block
      for (TextBlock block in recognizedTextFrommodel.blocks) {
        for (TextLine line in block.lines) {
          clinicRecognizedText += "${line.text} \n";
        }
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
    } finally {
      setState(() {
        isClinicRecognized = false;
      });
    }
  }
}
