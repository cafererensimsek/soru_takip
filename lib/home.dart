import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:soru_takip/list.dart';
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
  String _soruSayisi;
  String _yanlisSayisi;
  String _dersAdi;
  DateTime _tarih;
  String strTarih;
  int _selectedIndex = 0;
  String isim = 'yavuz';
  Color tahaIcon = Colors.black;
  Color yavuzIcon = Colors.deepPurple;
  List<String> dersListesi;

  @override
  void initState() {
    super.initState();
    soruSayisiController.addListener(changeSoruSayisi);
    yanlisSayisiController.addListener(changeYanlisSayisi);
    this.dersListesi = ['Matematik', 'Fen', 'Türkçe', 'Sosyal', 'İngilizce'];
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
                        strTarih = DateFormat('dd MM yyyy').format(pickedDate);
                      });
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: _tarih == null
                          ? Icon(Icons.date_range, size: 40)
                          : Text(strTarih, style: TextStyle(fontSize: 20)),
                    ),
                  );
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
                child: Icon(Icons.playlist_add, size: 40)),
          ],
        );
      },
    );
  }

  void _navigate(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        tahaIcon = Colors.white;
        yavuzIcon = Colors.blue;
        isim = 'yavuz';
        dersListesi = ['Matematik', 'Fen', 'Türkçe', 'Sosyal', 'İngilizce'];
      } else {
        tahaIcon = Colors.blue;
        yavuzIcon = Colors.white;
        isim = 'taha';
        dersListesi = ['Matematik', 'Geometri', 'Fizik', 'Kimya', 'Biyoloji'];
      }
    });
  }

  Widget soruListDisplay(BuildContext context) {
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
      backgroundColor: Colors.teal[300],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () => addSoru(context),
            child: Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.black,
          );
        },
      ),
      body: display(currentData, currentList, dersListesi, isim),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        elevation: 25,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              child: Row(children: [
                Icon(Icons.school, color: yavuzIcon),
                Text('   Yavuz', style: TextStyle(color: yavuzIcon)),
              ]),
              onPressed: () => _navigate(0),
            ),
            FlatButton(
                child: Row(
                  children: [
                    Text('Taha   ', style: TextStyle(color: tahaIcon)),
                    Icon(Icons.school, color: tahaIcon),
                  ],
                ),
                onPressed: () => _navigate(1)),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> get data {
    return Firestore.instance.collection(isim).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: data,
      child: StreamBuilder(
        stream: data,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loading(context);
          }
          return soruListDisplay(context);
        },
      ),
    );
  }
}
