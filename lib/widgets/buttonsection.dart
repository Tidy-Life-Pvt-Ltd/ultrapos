import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/customcolor.dart';

class ButtonSection extends StatelessWidget {
  double thick, height, width;
  final BorderRadiusGeometry? brdRadius;
  String txt;
  String fontFamily;
  Color txtColr;
  void Function()? btAction;
  Gradient gradient;

  ButtonSection(
      {required this.thick,
        required this.height,
        required this.width,
        required this.txt,
        this.brdRadius,
        required this.txtColr,
        required this.fontFamily,
        this.gradient = const LinearGradient(
            colors: [CustomColors.blue1, CustomColors.blue3]),
        this.btAction});

  @override
  Widget build(BuildContext context) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      child: ElevatedButton(
          child: Text(txt.toUpperCase(),
              style: TextStyle(
                color: txtColr,
                fontFamily: fontFamily,
              )),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  )
              )
          ),
          onPressed: btAction));
}
