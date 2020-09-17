import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<int> getData(QuerySnapshot current, bool isSum) {
  int toplamMat = 0;
  int toplamGeoFen = 0;
  int toplamFizTr = 0;
  int toplamKimSos = 0;
  int toplamBioIng = 0;
  int toplamMatY = 0;
  int toplamGeoFenY = 0;
  int toplamFizTrY = 0;
  int toplamKimSosY = 0;
  int toplamBioIngY = 0;
  int toplamTR = 0;
  int toplamTRY = 0;
  int toplamSos = 0;
  int toplamSosY = 0;
  if (current != null) {
    current.documents.forEach((element) {
      if (element.data['strTarih'] ==
              DateFormat('dd/MM/yyyy').format(DateTime.now()) ||
          isSum) {
        switch (element.data['dersAdi']) {
          case 'Matematik':
            toplamMat += element.data['soruSayisi'];
            toplamMatY += element.data['yanlisSayisi'];
            break;
          case 'Geometri':
          case 'Fen':
            toplamGeoFen += element.data['soruSayisi'];
            toplamGeoFenY += element.data['yanlisSayisi'];
            break;
          case 'Fizik':
          case 'Türkçe':
            toplamFizTr += element.data['soruSayisi'];
            toplamFizTrY += element.data['yanlisSayisi'];
            break;
          case 'Kimya':
          case 'Sosyal':
            toplamKimSos += element.data['soruSayisi'];
            toplamKimSosY += element.data['yanlisSayisi'];
            break;
          case 'Biyoloji':
          case 'İngilizce':
            toplamBioIng += element.data['soruSayisi'];
            toplamBioIngY += element.data['yanlisSayisi'];
            break;
          case 'Türkçe':
            toplamTR += element.data['soruSayisi'];
            toplamTRY += element.data['yanlisSayisi'];
            break;
          case 'Sosyal Bilimler':
            toplamSos += element.data['soruSayisi'];
            toplamSosY += element.data['yanlisSayisi'];
        }
      }
    });
  }
  return [
    toplamMat,
    toplamMatY,
    toplamGeoFen,
    toplamGeoFenY,
    toplamFizTr,
    toplamFizTrY,
    toplamKimSos,
    toplamKimSosY,
    toplamBioIng,
    toplamBioIngY,
    toplamTR,
    toplamTRY,
    toplamSos,
    toplamSosY,
  ];
}

class CollectiveDataTable extends StatelessWidget {
  final List<String> dersler;
  final bool isVisible;
  final List<int> collective;

  const CollectiveDataTable(this.dersler, this.isVisible, this.collective,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int iter = dersler.length * 2;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Visibility(
        visible: isVisible,
        child: Card(
          color: Colors.tealAccent,
          elevation: 3,
          child: DataTable(
            columns: [
              for (int i = 0; i < dersler.length; i++)
                DataColumn(
                    label: Text(dersler[i].split(" ")[0],
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
                      (collective[i] != collective[i + 1])
                          ? '% ' +
                              ((collective[i] - collective[i + 1]) /
                                      collective[i] *
                                      100)
                                  .toStringAsFixed(0)
                          : '-',
                      style: TextStyle(color: Colors.black, fontSize: 15))),
              ]),
            ],
            columnSpacing: 25,
          ),
        ),
      ),
    );
  }
}
