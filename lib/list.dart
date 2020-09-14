import 'package:flutter/material.dart';
import 'package:soru_takip/data_table.dart';
import 'package:soru_takip/delete.dart';
import 'package:soru_takip/soru.dart';

Widget display(
  List<Soru> currentList,
  List<String> dersListesi,
  String isim,
  bool isDailyVisible,
  bool isSumVisible,
  List<int> collectiveSum,
  List<int> collectiveDaily,
) {
  return Column(
    children: [
      SizedBox(height: 25),
      SingleChildScrollView(
        child: dataTable(dersListesi, isSumVisible, collectiveSum),
        scrollDirection: Axis.horizontal,
      ),
      SingleChildScrollView(
        child: dataTable(dersListesi, isDailyVisible, collectiveDaily),
        scrollDirection: Axis.horizontal,
      ),
      Expanded(
        child: ListView.builder(
          itemCount: currentList.length,
          itemBuilder: (BuildContext context, int index) {
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
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                tileColor: Colors.tealAccent,
              ),
            );
          },
        ),
      ),
    ],
  );
}
