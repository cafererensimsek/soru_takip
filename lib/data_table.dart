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
    }
  });
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
    toplamBioY
  ];
}

Widget dataTable(QuerySnapshot current, List<String> dersler) {
  List<int> collective = getData(current);

  return DataTable(
    columns: [
      DataColumn(
          label: Text(dersler[0],
              style: TextStyle(color: Colors.white, fontSize: 15))),
      DataColumn(
          label: Text(dersler[1],
              style: TextStyle(color: Colors.white, fontSize: 15))),
      DataColumn(
          label: Text(dersler[2],
              style: TextStyle(color: Colors.white, fontSize: 15))),
      DataColumn(
          label: Text(dersler[3],
              style: TextStyle(color: Colors.white, fontSize: 15))),
      DataColumn(
          label: Text(dersler[4],
              style: TextStyle(color: Colors.white, fontSize: 15))),
    ],
    rows: [
      DataRow(cells: [
        for (var i = 0; i < 10; i += 2)
          DataCell(Text('${collective[i]}',
              style: TextStyle(color: Colors.white, fontSize: 15))),
      ]),
      DataRow(cells: [
        for (var i = 1; i < 10; i += 2)
          DataCell(Text('${collective[i]}',
              style: TextStyle(color: Colors.white, fontSize: 15))),
      ]),
      DataRow(cells: [
        for (var i = 0; i < 10; i += 2)
          DataCell(Text(
              '% ' +
                  ((collective[i] - collective[i + 1]) / collective[i] * 100)
                      .toStringAsFixed(2),
              style: TextStyle(color: Colors.white, fontSize: 15))),
      ]),
    ],
    columnSpacing: 25,
  );
}
