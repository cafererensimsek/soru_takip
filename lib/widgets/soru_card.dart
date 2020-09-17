import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../soru.dart';

class SoruCard extends StatelessWidget {
  const SoruCard(this.currentList, this.isim, this.index, {Key key})
      : super(key: key);

  final List<Soru> currentList;
  final String isim;
  final int index;

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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        onLongPress: () => delete(currentList[index], context, isim),
        title: Row(
          children: [
            Icon(Icons.done, color: Colors.black, size: 20),
            SizedBox(width: 5),
            Text(
              currentList[index].soruSayisi > 10
                  ? '${currentList[index].soruSayisi}'
                  : '  ${currentList[index].soruSayisi}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 30),
            Icon(Icons.date_range, color: Colors.black, size: 20),
            SizedBox(width: 5),
            Text(
              '${currentList[index].strTarih}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Icon(Icons.error, color: Colors.black, size: 20),
            SizedBox(width: 5),
            Text(
              currentList[index].yanlisSayisi < 10
                  ? '  ${currentList[index].yanlisSayisi}'
                  : '${currentList[index].yanlisSayisi}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 30),
            Icon(Icons.description, color: Colors.black, size: 20),
            SizedBox(width: 5),
            Text(
              '${currentList[index].dersAdi}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.delete, color: Colors.black, size: 30),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        tileColor: Colors.tealAccent,
      ),
    );
  }
}
