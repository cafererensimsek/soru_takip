import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soru_takip/widgets/data_table.dart';
import 'package:soru_takip/soru.dart';
import 'package:soru_takip/widgets/soru_card.dart';

class Body extends StatelessWidget {
  final List<String> dersListesi;
  final String isim;
  final bool isDailyVisible;
  final bool isSumVisible;
  final QuerySnapshot currentData;

  const Body(this.dersListesi, this.isim, this.isDailyVisible,
      this.isSumVisible, this.currentData,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Soru> currentList = [];

    currentData.documents.forEach((element) {
      Soru soru = Soru(
          element.data['soruSayisi'],
          element.data['dersAdi'],
          element.data['yanlisSayisi'],
          DateTime.parse(element.data['tarih'].toDate().toString()),
          element.data['strTarih']);
      currentList.add(soru);
    });

    currentList.sort((a, b) => a.tarih.compareTo(b.tarih));
    currentList = currentList.reversed.toList();

    List<int> collectiveSum = getData(currentData, true);
    List<int> collectiveDaily = getData(currentData, false);

    return Column(
      children: [
        SizedBox(height: 25),
        CollectiveDataTable(dersListesi, isSumVisible, collectiveSum),
        CollectiveDataTable(dersListesi, isDailyVisible, collectiveDaily),
        Expanded(
          child: ListView.builder(
            itemCount: currentList.length,
            itemBuilder: (BuildContext context, int index) {
              return SoruCard(currentList, isim, index);
            },
          ),
        ),
      ],
    );
  }
}
