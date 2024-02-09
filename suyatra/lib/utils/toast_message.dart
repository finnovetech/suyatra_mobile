import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toastMessage(
    {required dynamic message,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    int timeInSecForIosWeb = 3,
    Toast toastLength = Toast.LENGTH_LONG,
      ToastGravity gravity = ToastGravity.BOTTOM,
    }) {
  Fluttertoast.showToast(
    msg: "$message",
    toastLength: toastLength,
    gravity: gravity,
    timeInSecForIosWeb: timeInSecForIosWeb,
    backgroundColor: backgroundColor,
    textColor: textColor,
    webPosition: "center",
    webBgColor: "white",
    // webShowClose: true,
    fontSize: 16.0,
  );
}

toastMessageWithContext({required BuildContext context,required dynamic message,
  Color backgroundColor = Colors.white, Color textColor = Colors.black,
  int timeInSecForIosWeb=3, Toast toastLength = Toast.LENGTH_LONG,
  ToastGravity toastGravity = ToastGravity.TOP,
}) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: backgroundColor,
    ),
    child: Text("$message", style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w400),),
  );

  fToast.showToast(
    child: toast,
    gravity: toastGravity,
    toastDuration: const Duration(seconds: 2),

  );
}
