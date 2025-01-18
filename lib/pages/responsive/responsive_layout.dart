import 'package:flutter/material.dart';
import 'package:healthcare/constants/app_constants.dart';

class ResponsiveLayoutSreen extends StatefulWidget {
  final Widget mobileScreenLayout;
  final Widget webSreenLayout;
  const ResponsiveLayoutSreen({
    super.key,
    required this.mobileScreenLayout,
    required this.webSreenLayout,
  });

  @override
  State<ResponsiveLayoutSreen> createState() => _ResponsiveLayoutSreenState();
}

class _ResponsiveLayoutSreenState extends State<ResponsiveLayoutSreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webSreenMinWidth) {
          return widget.webSreenLayout;
        } else {
          return widget.mobileScreenLayout;
        }
      },
    );
  }
}
