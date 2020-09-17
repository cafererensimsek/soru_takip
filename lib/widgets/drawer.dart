import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Cekmece extends StatelessWidget {
  void launchWhatsApp() async {
    String url() {
      return "whatsapp://send?phone=+905393631558";
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: ListView(
        children: [
          DrawerHeader(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Soru Takip', style: TextStyle(fontSize: 25)),
            ),
            decoration: BoxDecoration(color: Colors.teal),
          ),
          FlatButton(
            onPressed: () => launchWhatsApp(),
            child: Row(
              children: [
                Icon(Icons.bug_report),
                SizedBox(width: 10),
                Text('Bug Bildir'),
              ],
            ),
          ),
          FlatButton(
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Soru Takibi',
              applicationVersion: '1.0.0',
              applicationIcon: Icon(Icons.book),
            ),
            child: Row(
              children: [
                Icon(Icons.more_horiz),
                SizedBox(width: 10),
                Text('Hakkında'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
