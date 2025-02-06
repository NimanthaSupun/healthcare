import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthcare/models/sympton_model.dart';

class SingleSymptonPage extends StatefulWidget {
  final SymptonModel sympton;

  const SingleSymptonPage({
    Key? key,
    required this.sympton,
  }) : super(key: key);

  @override
  State<SingleSymptonPage> createState() => _SingleSymptonPageState();
}

class _SingleSymptonPageState extends State<SingleSymptonPage> {
  bool _downloading = false;

  // Future<void> _downloadImage(String imageUrl, String imageName) async {
  //   if (imageUrl.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('No image available to download')),
  //     );
  //     return;
  //   }

  //   try {
  //     setState(() => _downloading = true);

  //     // Request storage permission
  //     var status = await Permission.storage.request();
  //     if (!status.isGranted) {
  //       throw 'Storage permission denied';
  //     }

  //     // Download image
  //     var response = await Dio().get(
  //       imageUrl,
  //       options: Options(responseType: ResponseType.bytes),
  //     );

  //     // Save to gallery
  //     final result = await ImageGallerySaver.saveImage(
  //       Uint8List.fromList(response.data),
  //       name: imageName,
  //     );

  //     if (result['isSuccess']) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Image saved to gallery successfully')),
  //       );
  //     } else {
  //       throw 'Failed to save image';
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to download image: $e')),
  //     );
  //   } finally {
  //     setState(() => _downloading = false);
  //   }
  // }

  Widget _buildImageCard({
    required String title,
    required String imageUrl,
    required String downloadName,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.error_outline,
                      size: 40,
                      color: Colors.red,
                    ),
                  );
                },
                // loadingBuilder: (context, child, loadingProgress) {
                //   if (loadingProgress == null) return child;
                //   return Center(
                //     child: CircularProgressIndicator(
                //       value: loadingProgress.expectedTotalBytes != null
                //           ? loadingProgress.cumulativeBytesLoaded /
                //               loadingProgress.expectedTotalBytes!
                //           : null,
                //     ),
                //   );
                // },
              ),
            )
          else
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
              child: const Center(
                child: Text('No image available'),
              ),
            ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.remove_red_eye),
                label: const Text('View'),
                onPressed: imageUrl.isNotEmpty
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: Text(title),
                              ),
                              body: InteractiveViewer(
                                minScale: 0.5,
                                maxScale: 4.0,
                                child: Center(
                                  child: Image.memory(
                                    base64Decode(imageUrl),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    : null,
              ),
              TextButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Download'),
                onPressed:() {
                  // _downloading || imageUrl.isEmpty
                  //   ? null
                  //   : () => _downloadImage(imageUrl, downloadName) 
                }
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Details'),
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
            ),
            _buildImageCard(
              title: 'Doctor\'s Note',
              imageUrl: widget.sympton.doctorNoteImage ?? '',
              downloadName: 'doctor_note_${widget.sympton.name}',
            ),
            _buildImageCard(
              title: 'Clinic Note',
              imageUrl: widget.sympton.clinicNoteImage ?? '',
              downloadName: 'clinic_note_${widget.sympton.name}',
            ),
            _buildImageCard(
              title: 'Prescriptions',
              imageUrl: widget.sympton.precriptionsImage ?? '',
              downloadName: 'prescription_${widget.sympton.name}',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
