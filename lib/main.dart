import 'package:flutter/material.dart';
import 'package:soru_takip/home.dart';

void main() => runApp(SoruTakip());

class SoruTakip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soru Takip',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        dividerColor: Colors.white,
      ),
      home: Home(),
    );
  }
}
