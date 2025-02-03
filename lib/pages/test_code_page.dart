import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/health_category_model.dart';
import 'package:healthcare/services/category/symton_service.dart';

class TestCodePage extends StatefulWidget {
  final HealthCategory healthCategory;
  const TestCodePage({super.key, required this.healthCategory});

  @override
  State<TestCodePage> createState() => _TestCodePageState();
}

class _TestCodePageState extends State<TestCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: SymtonService().getSymptoms(
                  FirebaseAuth.instance.currentUser!.uid,
                  widget.healthCategory.id,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text("No data available"),
                    );
                  } else {
                    final symptons = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: symptons!.length,
                      itemBuilder: (context, index) {
                        final sympton = symptons[index];
                        return ListTile(
                          title: Text(sympton.name),
                          subtitle: Image.memory(
                            base64Decode(
                              sympton.medicalReportImage ?? '',
                            ),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
