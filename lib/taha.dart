import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soru_takip/soru.dart';
import 'package:soru_takip/widgets.dart';

class Taha extends StatefulWidget {
  @override
  _TahaState createState() => _TahaState();
}

class _TahaState extends State<Taha> {
  List<int> getCollectiveDataTaha(QuerySnapshot current) {
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
          toplamGeo += element.data['soruSayisi'];
          toplamGeoY += element.data['yanlisSayisi'];
          break;
        case 'Fizik':
          toplamFiz += element.data['soruSayisi'];
          toplamFizY += element.data['yanlisSayisi'];
          break;
        case 'Kimya':
          toplamKim += element.data['soruSayisi'];
          toplamKimY += element.data['yanlisSayisi'];
          break;
        case 'Biyoloji':
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

  Widget collectiveDataTaha(QuerySnapshot current) {
    List<int> collective = getCollectiveDataTaha(current);

    return DataTable(
      columns: [
        DataColumn(
            label: Text('Mat',
                style: TextStyle(color: Colors.white, fontSize: 15))),
        DataColumn(
            label: Text('Geo',
                style: TextStyle(color: Colors.white, fontSize: 15))),
        DataColumn(
            label: Text('Fiz',
                style: TextStyle(color: Colors.white, fontSize: 15))),
        DataColumn(
            label: Text('Kim',
                style: TextStyle(color: Colors.white, fontSize: 15))),
        DataColumn(
            label: Text('Bio',
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

  void delete(
    Soru soru,
    BuildContext ctx,
  ) {
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
                  .collection('taha')
                  .document(soru.strTarih + " " + soru.dersAdi)
                  .delete();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  Widget soruListDisplay(BuildContext context, CollectionReference database) {
    final currentData = Provider.of<QuerySnapshot>(context);

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

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(children: [
        SizedBox(height: 25),
        SingleChildScrollView(
          child: collectiveDataTaha(currentData),
          scrollDirection: Axis.horizontal,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: currentList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.deepPurple,
                child: ListTile(
                  onLongPress: () => delete(currentList[index], context),
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
      ]),
    );
  }

  Stream<QuerySnapshot> get currentData {
    return Firestore.instance.collection('taha').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference database = Firestore.instance.collection('taha');
    return StreamProvider<QuerySnapshot>.value(
      value: currentData,
      child: StreamBuilder(
        stream: currentData,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? soruListDisplay(context, database)
              : loading(context);
        },
      ),
    );
  }
}
