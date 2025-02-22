import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/health_category_model.dart';
import 'package:healthcare/models/sympton_model.dart';
import 'package:healthcare/pages/responsive/mobile_layout.dart';
import 'package:healthcare/pages/responsive/responsive_layout.dart';
import 'package:healthcare/pages/responsive/web_layout.dart';
import 'package:healthcare/services/category/image_saver_service.dart';
import 'package:healthcare/services/category/symton_service.dart';
import 'package:healthcare/widgets/single_category/category_botton_sheet.dart';

class SingleSymptonPage extends StatefulWidget {
  final SymptonModel sympton;
  final HealthCategory healthCategory;

  const SingleSymptonPage({
    super.key,
    required this.sympton,
    required this.healthCategory,
  });

  @override
  State<SingleSymptonPage> createState() => _SingleSymptonPageState();
}

class _SingleSymptonPageState extends State<SingleSymptonPage> {
  bool _downloading = false;

  Future<void> _downloadBase64Image(
      String base64String, String fileName) async {
    if (base64String.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image available')),
      );
      return;
    }

    setState(() => _downloading = true);
    try {
      final bytes = base64Decode(base64String);
      await ImageService.saveBytes(bytes, fileName);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image saved successfully')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save image: $e')),
      );
    } finally {
      setState(() => _downloading = false);
    }
  }

  Widget _buildImageCard({
    required String title,
    required String imageUrl,
    required String downloadName,
    required String type,
    required String processText,
  }) {
    return Card(
      elevation: 4,
      shadowColor: mainLandMarksColor,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (imageUrl.isNotEmpty)
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.memory(
                  base64Decode(imageUrl),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child:
                        Icon(Icons.error_outline, size: 40, color: Colors.red),
                  ),
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Center(child: Text('No image available')),
              ),
            OverflowBar(
              alignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 15,
                ),
                processText.isNotEmpty
                    ? TextButton.icon(
                        icon: const Icon(
                          Icons.auto_awesome_sharp,
                          size: 25,
                          color: mainPurpleColor,
                        ),
                        label: const Text(
                          'process Text',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: mainPurpleColor,
                          ),
                        ),
                        onPressed: imageUrl.isNotEmpty
                            ? () =>
                                _viewProcessText(context, title, processText)
                            : null,
                      )
                    : Text(""),
                TextButton.icon(
                  icon: const Icon(Icons.remove_red_eye),
                  label: const Text(
                    'View',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: imageUrl.isNotEmpty
                      ? () => _viewImage(context, title, imageUrl)
                      : null,
                ),
                TextButton.icon(
                  icon: const Icon(
                    Icons.download,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Download',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: imageUrl.isNotEmpty && !_downloading
                      ? () => _downloadBase64Image(imageUrl, downloadName)
                      : null,
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _viewImage(BuildContext context, String title, String base64Image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Image.memory(base64Decode(base64Image)),
            ),
          ),
        ),
      ),
    );
  }

  void _viewProcessText(
      BuildContext context, String title, String processText) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [Text(processText)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _deleteSympton(BuildContext context) async {
    try {
      SymtonService().deleteSympton(
        FirebaseAuth.instance.currentUser!.uid,
        widget.healthCategory.id,
        widget.sympton.id,
      );

      UtilFunctions().showSnackBarWdget(
        // ignore: use_build_context_synchronously
        context,
        "Sympton record deleted successfully",
      );

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();

      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayoutSreen(
            mobileScreenLayout: MobileSreenLayout(),
            webSreenLayout: WebSreenLayout(),
          ),
        ),
      );
    } catch (error) {
      print("Error: {error}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Details'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return CategoryBottonSheet(
                    deleteCallback: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Delete",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            content: Text(
                              "Are you sure you want to delete this",
                              style: TextStyle(
                                color: mainOrangeColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () => _deleteSympton(context),
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    editCallback: () {},
                    title1: "Delete Sympton Report's",
                    title2: "Edit Sympton Report's",
                  );
                },
              );
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sympton.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                ],
              ),
            ),
            if (_downloading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('Downloading image...'),
                    ],
                  ),
                ),
              ),
            _buildImageCard(
                title: 'Medical Report',
                imageUrl: widget.sympton.medicalReportImage ?? '',
                downloadName: 'medical_report_${widget.sympton.name}',
                type: 'medical',
                processText: widget.sympton.medicalProccessText ?? ''),
            _buildImageCard(
              title: 'Doctor\'s Note',
              imageUrl: widget.sympton.doctorNoteImage ?? '',
              downloadName: 'doctor_note_${widget.sympton.name}',
              type: 'doctor',
              processText: widget.sympton.doctorProcessText ?? '',
            ),
            _buildImageCard(
              title: 'Clinic Note',
              imageUrl: widget.sympton.clinicNoteImage ?? '',
              downloadName: 'clinic_note_${widget.sympton.name}',
              type: 'clinic',
              processText: widget.sympton.clinicalProccessText ?? '',
            ),
            _buildImageCard(
                title: 'Prescriptions',
                imageUrl: widget.sympton.precriptionsImage ?? '',
                downloadName: 'prescription_${widget.sympton.name}',
                type: 'prescription',
                processText: widget.sympton.precriptionsProcessText ?? ''),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
