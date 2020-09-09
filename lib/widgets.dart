import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget snackbar(txt) {
  return SnackBar(
    content: Row(
      children: [
        Icon(Icons.error_outline),
        SizedBox(width: 30),
        Flexible(child: Text(txt)),
      ],
    ),
  );
}

Widget loading(context) {
  return Scaffold(
    backgroundColor: Theme.of(context).accentColor,
    body: Center(
      child: SpinKitFadingCube(
        color: Theme.of(context).primaryColor,
        size: 100.0,
      ),
    ),
  );
}

Widget textInput(
    {TextEditingController controller,
    String hintText,
    Icon icon,
    bool obscure = false,
    TextInputType keyboardType}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
    child: TextField(
      cursorColor: Colors.black,
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: Colors.black),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black),
        icon: icon,
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(color: Colors.black)),
      ),
    ),
  );
}
