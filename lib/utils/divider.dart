

import 'package:flutter/material.dart';

class DividerSec extends StatelessWidget {
  double thick;
  int from;
  Color colr;

  DividerSec({required this.thick, required this.from,required this.colr,});

  @override
  Widget build(BuildContext context) {
    if (from == 1)
      return VerticalDivider(
        thickness: thick,
        color: colr,
      );
    else
      return Divider(
        thickness: thick,
        color: colr,
      );
  }

}