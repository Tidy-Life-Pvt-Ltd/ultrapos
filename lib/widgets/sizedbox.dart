import 'package:flutter/material.dart';

class SizedBoxSection extends StatelessWidget {
  double height;
  double width;
  SizedBoxSection({required this.height,required this.width});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: width,
  );
}
