import 'package:flutter/material.dart';
import 'package:soru_takip/taha.dart';
import 'package:soru_takip/yavuz.dart';

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
      routes: {
        '/': (BuildContext context) => Yavuz(),
        '/taha': (BuildContext context) => Taha(),
      },
      initialRoute: '/',
    );
  }
}
