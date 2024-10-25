import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ToastMessage{
  static  void showSnackBar(BuildContext context,String title,String description) {
    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static  void showSnackBarWithoutTitle(BuildContext context,String description) {

    Fluttertoast.showToast(
        msg: description,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

