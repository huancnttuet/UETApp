import 'package:flutter/material.dart';

class CustomAlertDialog {
  static void showConfirmAlertDialog(BuildContext context, press) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Đồng ý"),
      onPressed: press,
    );
    Widget continueButton = TextButton(
      child: Text("Không"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("AlertDialog"),
      content: Text("Bạn có muốn thoát không ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
