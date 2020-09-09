import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soru_takip/data_table.dart';
import 'package:soru_takip/delete.dart';
import 'package:soru_takip/soru.dart';

Widget display(
  QuerySnapshot currentData,
  List<Soru> currentList,
  List<String> dersListesi,
  String isim,
) {
  return Column(children: [
    SizedBox(height: 25),
    SingleChildScrollView(
      child: dataTable(currentData, dersListesi),
      scrollDirection: Axis.horizontal,
    ),
    Expanded(
      child: ListView.builder(
        itemCount: currentList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.deepPurple,
            child: ListTile(
              onLongPress: () => delete(currentList[index], context, isim),
              title: Text(
                  'Soru Sayısı: ${currentList[index].soruSayisi}, Yanlış Sayısı: ${currentList[index].yanlisSayisi}'),
              subtitle: Text(
                  '${currentList[index].dersAdi} \n${currentList[index].strTarih}'),
              isThreeLine: true,
            ),
          );
        },
      ),
    ),
  ]);
}
