import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soru_takip/soru.dart';
import 'package:soru_takip/widgets.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final soruSayisiController = TextEditingController();
  final yanlisSayisiController = TextEditingController();
  final dersAdiController = TextEditingController();
  String _soruSayisi;
  String _yanlisSayisi;
  String _dersAdi;
  String _tarih;

  @override
  void initState() {
    super.initState();
    soruSayisiController.addListener(changeSoruSayisi);
    yanlisSayisiController.addListener(changeYanlisSayisi);
  }

  @override
  void dispose() {
    soruSayisiController.dispose();
    yanlisSayisiController.dispose();
    super.dispose();
  }

  changeSoruSayisi() {
    _soruSayisi = soruSayisiController.text;
  }

  changeYanlisSayisi() {
    _yanlisSayisi = yanlisSayisiController.text;
  }

  void ekle(
    BuildContext ctx,
    String soruSayisi,
    String yanlisSayisi,
    String dersAdi,
    String tarih,
  ) {
    if (soruSayisi == null ||
        yanlisSayisi == null ||
        dersAdi == null ||
        tarih == null) {
      Scaffold.of(ctx).showSnackBar(snackbar('Bütün alanları doldurun!'));
      return;
    }

    var db =
        Firestore.instance.collection('yavuz').document(tarih + " " + dersAdi);
    int soru = int.parse(soruSayisi);
    int yanlis = int.parse(yanlisSayisi);
    db.setData({
      'soruSayisi': FieldValue.increment(soru),
      'yanlisSayisi': FieldValue.increment(yanlis),
      'dersAdi': dersAdi,
      'tarih': tarih,
    }, merge: true);
    Navigator.pop(ctx);
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _tarih = DateFormat('dd MMM yyyy').format(pickedDate);
      });
    });
  }

  Widget dropdownMenu() {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Center(
          child: DropdownButton<String>(
            hint: Text(
              'Ders',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            value: _dersAdi,
            icon: Icon(Icons.arrow_downward, color: Colors.white),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.amber, fontSize: 20),
            underline: Container(
              height: 2,
              color: Colors.white,
            ),
            onChanged: (String newValue) {
              setState(() {
                _dersAdi = newValue;
              });
            },
            items: <String>['Matematik', 'Fen', 'Türkçe', 'Sosyal', 'İngilizce']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void addSoru(BuildContext ctx) {
    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: ctx,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton(
                color: Colors.white,
                onPressed: _showDatePicker,
                child: Text('Tarih Seç', style: TextStyle(fontSize: 25))),
            textInput(
                controller: soruSayisiController,
                hintText: 'Soru Sayısı',
                keyboardType: TextInputType.number),
            textInput(
                controller: yanlisSayisiController,
                hintText: 'Yanlış Sayısı',
                keyboardType: TextInputType.number),
            dropdownMenu(),
            FlatButton(
                color: Colors.amber,
                onPressed: () =>
                    ekle(context, _soruSayisi, _yanlisSayisi, _dersAdi, _tarih),
                child: Text('Ekle',
                    style: TextStyle(color: Colors.white, fontSize: 20))),
          ],
        );
      },
    );
  }

  List<int> getCollectiveData(QuerySnapshot current) {
    int toplamMat = 0;
    int toplamFen = 0;
    int toplamSos = 0;
    int toplamTR = 0;
    int toplamIng = 0;
    int toplamMatY = 0;
    int toplamFenY = 0;
    int toplamSosY = 0;
    int toplamTRY = 0;
    int toplamIngY = 0;
    current.documents.forEach((element) {
      switch (element.data['dersAdi']) {
        case 'Matematik':
          toplamMat += element.data['soruSayisi'];
          toplamMatY += element.data['yanlisSayisi'];
          break;
        case 'Fen':
          toplamFen += element.data['soruSayisi'];
          toplamFenY += element.data['yanlisSayisi'];
          break;
        case 'Sosyal':
          toplamSos += element.data['soruSayisi'];
          toplamSosY += element.data['yanlisSayisi'];
          break;
        case 'Türkçe':
          toplamTR += element.data['soruSayisi'];
          toplamTRY += element.data['yanlisSayisi'];
          break;
        case 'İngilizce':
          toplamIng += element.data['soruSayisi'];
          toplamIngY += element.data['yanlisSayisi'];
          break;
      }
    });
    return [
      toplamMat,
      toplamMatY,
      toplamFen,
      toplamFenY,
      toplamTR,
      toplamTRY,
      toplamSos,
      toplamSosY,
      toplamIng,
      toplamIngY
    ];
  }

  Widget collectiveData(QuerySnapshot current) {
    List<int> collective = getCollectiveData(current);

    return DataTable(columns: [
      DataColumn(label: Text('Mat')),
      DataColumn(label: Text('Fen')),
      DataColumn(label: Text('TR')),
      DataColumn(label: Text('Sos')),
      DataColumn(label: Text('İng')),
    ], rows: [
      DataRow(cells: [
        for (var i = 0; i < 10; i += 2) DataCell(Text('${collective[i]}')),
      ]),
      DataRow(cells: [
        for (var i = 1; i < 10; i += 2) DataCell(Text('${collective[i]}')),
      ]),
      DataRow(cells: [
        for (var i = 0; i < 10; i += 2)
          DataCell(Text('% ' +
              ((collective[i] - collective[i + 1]) / collective[i] * 100)
                  .toStringAsFixed(2))),
      ]),
    ]);
  }

  Widget soruListDisplay(BuildContext context, CollectionReference database) {
    final currentData = Provider.of<QuerySnapshot>(context);

    List<Soru> currentList = [];
    currentData.documents.forEach((element) {
      Soru soru = Soru(element.data['soruSayisi'], element.data['dersAdi'],
          element.data['yanlisSayisi'], element.data['tarih']);
      currentList.add(soru);
    });

    return Scaffold(
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton.extended(
            onPressed: () => addSoru(context),
            label: Text('Veri Ekle'),
            elevation: 5,
            icon: Icon(Icons.add),
          );
        },
      ),
      body: Column(children: [
        SizedBox(height: 25),
        collectiveData(currentData),
        Expanded(
          child: ListView(
            children: [
              for (Soru soru in currentList.reversed)
                Card(
                  child: ListTile(
                    title: Text(
                        'Soru Sayısı: ${soru.soruSayisi}, Yanlış Sayısı: ${soru.yanlisSayisi}'),
                    subtitle: Text('${soru.dersAdi} \n${soru.tarih}'),
                    isThreeLine: true,
                  ),
                ),
            ],
          ),
        ),
      ]),
    );
  }

  Stream<QuerySnapshot> get currentData {
    return Firestore.instance.collection('yavuz').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference database = Firestore.instance.collection('yavuz');
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
