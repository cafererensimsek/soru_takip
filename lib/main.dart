import 'package:flutter/material.dart';
import 'package:soru_takip/taha.dart';
import 'package:soru_takip/yavuz.dart';

void main() => runApp(SoruTakip());

class SoruTakip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soru Takip',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (BuildContext context) => Yavuz(),
        '/taha': (BuildContext context) => Taha(),
      },
      initialRoute: '/',
    );
  }
}

/* class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String _email;
  String _password;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_changeEmail);
    passwordController.addListener(_changePassword);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  _changeEmail() {
    _email = emailController.text;
  }

  _changePassword() {
    _password = passwordController.text;
  }

  void auth(BuildContext context) async {
    try {
      FirebaseUser user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password))
          .user;
      user.email == "tahanuman04@gmail.com"
          ? Navigator.pushNamedAndRemoveUntil(
              context, '/taha', (route) => false, arguments: {'user': user})
          : Navigator.pushNamedAndRemoveUntil(
              context, '/yavuz', (route) => false,
              arguments: {'user': user});
    } catch (e) {
      switch (e.code) {
        case "ERROR_USER_NOT_FOUND":
          if (_password.length > 5) {
            try {
              FirebaseUser user = (await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _email, password: _password))
                  .user;
              user.email == "tahanuman04@gmail.com"
                  ? Navigator.pushNamedAndRemoveUntil(
                      context, '/taha', (route) => false,
                      arguments: {'user': user})
                  : Navigator.pushNamedAndRemoveUntil(
                      context, '/yavuz', (route) => false,
                      arguments: {'user': user});
            } catch (e) {
              Scaffold.of(context).showSnackBar(snackbar(e.message));
            }
          } else {
            Scaffold.of(context).showSnackBar(
                snackbar('Password must be at least 6 characters long!'));
          }
          break;
        default:
          Scaffold.of(context).showSnackBar(snackbar(e.message));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Builder(builder: (BuildContext context) {
          return Column(children: [
            SizedBox(height: 250),
            Text('Giriş Yap',
                style: TextStyle(color: Colors.white, fontSize: 25)),
            SizedBox(height: 50),
            textInput(
                controller: emailController,
                hintText: 'Email',
                //icon: Icon(Icons.email, color: Colors.white),
                keyboardType: TextInputType.emailAddress),
            textInput(
                controller: passwordController,
                hintText: 'Şifre',
                //icon: Icon(Icons.vpn_key, color: Colors.white),
                obscure: true),
            FlatButton(
              color: Colors.transparent,
              child: Text(
                'Giriş Yap',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => auth(context),
            ),
          ]);
        }),
      ),
    );
  }
}
 */
