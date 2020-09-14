import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soru_takip/soru.dart';

void delete(Soru soru, BuildContext ctx, String isim) {
  showDialog(
    context: ctx,
    builder: (BuildContext context) => AlertDialog(
      elevation: 24,
      title: Text('Silinecek!'),
      content: Text('Silmek istediğinize emin misiniz?'),
      actions: [
        SimpleDialogOption(
          child: Text('Hayır'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SimpleDialogOption(
          child: Text('Evet'),
          onPressed: () {
            Firestore.instance
                .collection(isim)
                .document(
                    soru.strTarih.replaceAll('/', ' ') + " " + soru.dersAdi)
                .delete();
            Navigator.pop(context);
          },
        ),
      ],
    ),
    barrierDismissible: true,
  );
}
