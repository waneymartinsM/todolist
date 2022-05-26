import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

showAlertDialog(context, AlertType alertType, String title, String mensagem){
  Alert(
    context: context,
    type: alertType,
    title: title,
    style: const AlertStyle(
      backgroundColor: Colors.white,
      titleStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700
      ),
      descStyle: TextStyle(
        color: Colors.black,
      ),
    ),
    desc: mensagem,
    buttons: [
      DialogButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: const Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
          color:  const Color(0xff1F1F30)
      )
    ],
  ).show();
}