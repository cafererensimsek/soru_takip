import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List<int> getData(QuerySnapshot current) {
  int toplamMat = 0;
  int toplamGeo = 0;
  int toplamFiz = 0;
  int toplamKim = 0;
  int toplamBio = 0;
  int toplamMatY = 0;
  int toplamGeoY = 0;
  int toplamFizY = 0;
  int toplamKimY = 0;
  int toplamBioY = 0;
  int toplamTR = 0;
  int toplamTRY = 0;
  if (current != null) {
    current.documents.forEach((element) {
      switch (element.data['dersAdi']) {
        case 'Matematik':
          toplamMat += element.data['soruSayisi'];
          toplamMatY += element.data['yanlisSayisi'];
          break;
        case 'Geometri':
        case 'Fen':
          toplamGeo += element.data['soruSayisi'];
          toplamGeoY += element.data['yanlisSayisi'];
          break;
        case 'Fizik':
        case 'Türkçe':
          toplamFiz += element.data['soruSayisi'];
          toplamFizY += element.data['yanlisSayisi'];
          break;
        case 'Kimya':
        case 'Sosyal':
          toplamKim += element.data['soruSayisi'];
          toplamKimY += element.data['yanlisSayisi'];
          break;
        case 'Biyoloji':
        case 'İngilizce':
          toplamBio += element.data['soruSayisi'];
          toplamBioY += element.data['yanlisSayisi'];
          break;
        case 'Türkçe':
          toplamTR += element.data['soruSayisi'];
          toplamTRY += element.data['yanlisSayisi'];
      }
    });
  }
  return [
    toplamMat,
    toplamMatY,
    toplamGeo,
    toplamGeoY,
    toplamFiz,
    toplamFizY,
    toplamKim,
    toplamKimY,
    toplamBio,
    toplamBioY,
    toplamTR,
    toplamTRY,
  ];
}

Widget dataTable(QuerySnapshot current, List<String> dersler, String isim) {
  List<int> collective = getData(current);

  int iter = isim == 'taha' ? 12 : 10;

  return DataTable(
    columns: [
      for (int i = 0; i < dersler.length; i++)
        DataColumn(
            label: Text(dersler[i],
                style: TextStyle(color: Colors.black, fontSize: 15))),
    ],
    rows: [
      DataRow(cells: [
        for (var i = 0; i < iter; i += 2)
          DataCell(Text('${collective[i]}',
              style: TextStyle(color: Colors.black, fontSize: 15))),
      ]),
      DataRow(cells: [
        for (var i = 1; i < iter; i += 2)
          DataCell(Text('${collective[i]}',
              style: TextStyle(color: Colors.black, fontSize: 15))),
      ]),
      DataRow(cells: [
        for (var i = 0; i < iter; i += 2)
          DataCell(Text(
              '% ' +
                  ((collective[i] - collective[i + 1]) / collective[i] * 100)
                      .toStringAsFixed(2),
              style: TextStyle(color: Colors.black, fontSize: 15))),
      ]),
    ],
    columnSpacing: 25,
  );
}
