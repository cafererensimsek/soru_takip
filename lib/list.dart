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
  return Column(
    children: [
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
              elevation: 3,
              child: ListTile(
                onLongPress: () => delete(currentList[index], context, isim),
                title: Row(
                  children: [
                    Icon(Icons.done, color: Colors.black, size: 30),
                    SizedBox(width: 5),
                    Text(
                      '${currentList[index].soruSayisi}',
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
                    Icon(Icons.error, color: Colors.black, size: 30),
                    SizedBox(width: 5),
                    Text(
                      currentList[index].yanlisSayisi < 10
                          ? '0${currentList[index].yanlisSayisi}'
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
                contentPadding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                tileColor: Colors.tealAccent,
              ),
            );
          },
        ),
      ),
    ],
  );
}