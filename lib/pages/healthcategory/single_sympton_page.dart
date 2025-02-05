import 'package:flutter/material.dart';
import 'package:healthcare/models/sympton_model.dart';

class SingleSymptonPage extends StatelessWidget {
  final SymptonModel sympton;
  const SingleSymptonPage({super.key, required this.sympton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
