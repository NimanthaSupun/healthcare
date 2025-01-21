import 'package:flutter/material.dart';

class MyCustomRouteTransition extends PageRouteBuilder {
  final Widget route;
MyCustomRouteTransition({required this.route})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return route;
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween(
              begin: const Offset(1, 0),
              end: Offset(0, 0),
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            );

            return SlideTransition(
              position: tween,
              child: child,
            );
          },
        );
}
