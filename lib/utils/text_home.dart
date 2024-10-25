import 'package:flutter/material.dart';
import 'package:intl/src/intl/number_format.dart';

class CustomTextField extends StatelessWidget {
  double size;
  String txt, font;
  Color colr;
  FontWeight fontWeight;
  TextAlign textAlign;
  bool softWrap;
  TextOverflow overflow;
  TextStyle? style;
  NumberFormat? numberFormat;

  CustomTextField(
      {this.size = 0,
        this.textAlign = TextAlign.center,
        required this.txt,
        required this.colr,
        required this.fontWeight,
        required this.font,
        this.softWrap = true,
        this.overflow = TextOverflow.visible,
        this.style,
        this.numberFormat
      });

  @override
  Widget build(BuildContext context) => size != 0
      ? Text(
    txt,
    textAlign: textAlign,
    style: TextStyle(
        fontWeight: fontWeight,
        color: colr,
        height: 1.2,
        fontSize: size,
        fontFamily: font),
  )
      : Text(
    txt,
    textAlign: textAlign,
    style: TextStyle(
        fontWeight: fontWeight,
        height: 1.2,
        color: colr,
        fontFamily: font),
  );
}
