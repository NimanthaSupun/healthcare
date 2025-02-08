// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:healthcare/models/health_category_model.dart';
// import 'package:healthcare/services/category/symton_service.dart';

// class TestCodePage extends StatefulWidget {
//   final HealthCategory healthCategory;
//   const TestCodePage({super.key, required this.healthCategory});

//   @override
//   State<TestCodePage> createState() => _TestCodePageState();
// }

// class _TestCodePageState extends State<TestCodePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               StreamBuilder(
//                 stream: SymtonService().getSymptoms(
//                   FirebaseAuth.instance.currentUser!.uid,
//                   widget.healthCategory.id,
//                 ),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   } else if (snapshot.hasError) {
//                     return Center(
//                       child: Text("Error: ${snapshot.error}"),
//                     );
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return Center(
//                       child: Text("No data available"),
//                     );
//                   } else {
//                     final symptons = snapshot.data;
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: symptons!.length,
//                       itemBuilder: (context, index) {
//                         final sympton = symptons[index];
//                         return ListTile(
//                           title: Text(sympton.name),
//                           subtitle: Image.memory(
//                             base64Decode(
//                               sympton.medicalReportImage ?? '',
//                             ),
//                             fit: BoxFit.cover,
//                           ),
//                         );
//                       },
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


//  floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [

//           FloatingActionButton(
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       TestCodePage(healthCategory: widget.healthCategory),
//                 ),
//               );
//             },
//             child: Icon(Icons.add),
//           ),
//         ],
//       ),


// todo: image_download page

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:healthcare/models/sympton_model.dart';
// import 'package:healthcare/services/category/image_saver_service.dart';
// import 'package:image_picker/image_picker.dart';

// class SingleSymptonPage extends StatefulWidget {
//   final SymptonModel sympton;

//   const SingleSymptonPage({
//     Key? key,
//     required this.sympton,
//   }) : super(key: key);

//   @override
//   State<SingleSymptonPage> createState() => _SingleSymptonPageState();
// }

// class _SingleSymptonPageState extends State<SingleSymptonPage> {
//   bool _downloading = false;

//   XFile? _selectedClinicNoteImage;
// String? _base64ClinicNoteImage;

// Future<void> _pickedClinicNote(ImageSource source) async {
//   _base64ClinicNoteImage = await ImageService.handleImagePick(
//     source,
//     (image) => setState(() => _selectedClinicNoteImage = image),
//   );
// }



//   Widget _buildImageCard({
//     required String title,
//     required String imageUrl,
//     required String downloadName,
//   }) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           if (imageUrl.isNotEmpty)
//             SizedBox(
//               height: 200,
//               width: double.infinity,
//               child: Image.memory(
//                 base64Decode(imageUrl),
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Center(
//                     child: Icon(
//                       Icons.error_outline,
//                       size: 40,
//                       color: Colors.red,
//                     ),
//                   );
//                 },
//               ),
//             )
//           else
//             Container(
//               height: 200,
//               width: double.infinity,
//               color: Colors.grey[200],
//               child: const Center(
//                 child: Text('No image available'),
//               ),
//             ),
//           ButtonBar(
//             alignment: MainAxisAlignment.end,
//             children: [
//               TextButton.icon(
//                 icon: const Icon(Icons.remove_red_eye),
//                 label: const Text('View'),
//                 onPressed: imageUrl.isNotEmpty
//                     ? () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => Scaffold(
//                               appBar: AppBar(
//                                 title: Text(title),
//                               ),
//                               body: InteractiveViewer(
//                                 minScale: 0.5,
//                                 maxScale: 4.0,
//                                 child: Center(
//                                   child: Image.memory(
//                                     base64Decode(imageUrl),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }
//                     : null,
//               ),
//               TextButton.icon(
//                 icon: const Icon(Icons.download),
//                 label: const Text('Download'),
//                  onPressed: ,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Symptom Details'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.sympton.name,
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Divider(),
//                 ],
//               ),
//             ),
//             if (_downloading)
//               const Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Center(
//                   child: Column(
//                     children: [
//                       CircularProgressIndicator(),
//                       SizedBox(height: 8),
//                       Text('Downloading image...'),
//                     ],
//                   ),
//                 ),
//               ),
//             _buildImageCard(
//               title: 'Medical Report',
//               imageUrl: widget.sympton.medicalReportImage ?? '',
//               downloadName: 'medical_report_${widget.sympton.name}',
//             ),
//             _buildImageCard(
//               title: 'Doctor\'s Note',
//               imageUrl: widget.sympton.doctorNoteImage ?? '',
//               downloadName: 'doctor_note_${widget.sympton.name}',
//             ),
//             _buildImageCard(
//               title: 'Clinic Note',
//               imageUrl: widget.sympton.clinicNoteImage ?? '',
//               downloadName: 'clinic_note_${widget.sympton.name}',
//             ),
//             _buildImageCard(
//               title: 'Prescriptions',
//               imageUrl: widget.sympton.precriptionsImage ?? '',
//               downloadName: 'prescription_${widget.sympton.name}',
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }
