import 'package:flutter/material.dart';

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
    return const Placeholder();
  }
}
