import 'package:flutter/material.dart';

class HeaderGradient extends StatelessWidget {
  const HeaderGradient({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black87],
        ),
      ),
    );
  }
}