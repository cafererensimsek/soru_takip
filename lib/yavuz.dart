import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:soru_takip/soru.dart';
import 'package:soru_takip/taha.dart';
import 'package:soru_takip/widgets.dart';
import 'package:intl/intl.dart';

class Yavuz extends StatefulWidget {
  @override
  _YavuzState createState() => _YavuzState();
}

class _YavuzState extends State<Yavuz> {
  final soruSayisiController = TextEditingController();
  final yanlisSayisiController = TextEditingController();
  final dersAdiController = TextEditingController();
  String _soruSayisi;
  String _yanlisSayisi;
  String _dersAdi;
  DateTime _tarih;
  String strTarih;
  int _selectedIndex = 0;
  String isim = 'yavuz';
  Color tahaIcon = Colors.black;
  Color yavuzIcon = Colors.deepPurple;
  List<String> dersListesi = [
    'Matematik',
    'Fen',
    'Türkçe',
    'Sosyal',
    'İngilizce',
  ];

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
    String strTarih,
    DateTime tarih,
  ) {
    if (soruSayisi == null ||
        yanlisSayisi == null ||
        dersAdi == null ||
        strTarih == null) {
      setState(() {
        _dersAdi = null;
        _tarih = null;
      });
      Navigator.pop(context);
      return;
    }

    var db =
        Firestore.instance.collection(isim).document(strTarih + " " + dersAdi);
    int soru = int.parse(soruSayisi);
    int yanlis = int.parse(yanlisSayisi);
    db.setData({
      'soruSayisi': FieldValue.increment(soru),
      'yanlisSayisi': FieldValue.increment(yanlis),
      'dersAdi': dersAdi,
      'strTarih': strTarih,
      'tarih': tarih,
    }, merge: true);

    setState(() {
      _dersAdi = null;
      _tarih = null;
    });
    Navigator.pop(ctx);
  }

  Widget dropdownMenu() {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Center(
          child: DropdownButton<String>(
            hint: Text(
              'Ders',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            value: _dersAdi,
            icon: Icon(Icons.arrow_downward, color: Colors.black),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 20),
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            onChanged: (String newValue) {
              setState(() {
                _dersAdi = newValue;
              });
            },
            items: dersListesi.map<DropdownMenuItem<String>>((String value) {
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
      backgroundColor: Colors.cyan[600],
      context: ctx,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: StatefulBuilder(
                builder: (BuildContext context, setState) {
                  return FlatButton(
                      color: Colors.transparent,
                      onPressed: () => showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          ).then((pickedDate) {
                            if (pickedDate == null) {
                              return;
                            }
                            setState(() {
                              _tarih = pickedDate;
                              strTarih =
                                  DateFormat('dd MM yyyy').format(pickedDate);
                            });
                          }),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: _tarih == null
                            ? Text('Tarih Seç', style: TextStyle(fontSize: 20))
                            : Text(strTarih, style: TextStyle(fontSize: 20)),
                      ));
                },
              ),
            ),
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
                color: Colors.transparent,
                onPressed: () => ekle(
                      context,
                      _soruSayisi,
                      _yanlisSayisi,
                      _dersAdi,
                      strTarih,
                      _tarih,
                    ),
                child: Text('Ekle',
                    style: TextStyle(color: Colors.black, fontSize: 20))),
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

    return DataTable(
      columns: [
        DataColumn(
            label: Text('Mat',
                style: TextStyle(color: Colors.white, fontSize: 15))),
        DataColumn(
            label: Text('Fen',
                style: TextStyle(color: Colors.white, fontSize: 15))),
        DataColumn(
            label: Text('TR',
                style: TextStyle(color: Colors.white, fontSize: 15))),
        DataColumn(
            label: Text('Sos',
                style: TextStyle(color: Colors.white, fontSize: 15))),
        DataColumn(
            label: Text('İng',
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

  void delete(Soru soru, BuildContext ctx) {
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
                  .collection('yavuz')
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

  void _navigate(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        tahaIcon = Colors.black;
        yavuzIcon = Colors.deepPurple;
        isim = 'yavuz';
        dersListesi = ['Matematik', 'Fen', 'Türkçe', 'Sosyal', 'İngilizce'];
      } else {
        tahaIcon = Colors.deepPurple;
        yavuzIcon = Colors.black;
        isim = 'taha';
        dersListesi = ['Matematik', 'Geometri', 'Fizik', 'Kimya', 'Biyoloji'];
      }
    });
  }

  Widget displayYavuz(
    QuerySnapshot currentData,
    List<Soru> currentList,
  ) {
    return Column(children: [
      SizedBox(height: 25),
      SingleChildScrollView(
        child: collectiveData(currentData),
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
    ]);
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

    List<dynamic> bodyList = [displayYavuz(currentData, currentList), Taha()];

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () => addSoru(context),
            child: Icon(Icons.add, color: Colors.black),
            backgroundColor: Colors.limeAccent,
          );
        },
      ),
      body: bodyList[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.lime,
        elevation: 25,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.school, color: yavuzIcon),
                  onPressed: () => _navigate(0),
                ),
                Text('Yavuz'),
              ],
            ),
            Row(
              children: [
                Text('Taha'),
                IconButton(
                    icon: Icon(Icons.school, color: tahaIcon),
                    onPressed: () => _navigate(1)),
              ],
            ),
          ],
        ),
      ),
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
