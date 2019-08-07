import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lkc/localization/application.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rich_alert/rich_alert.dart';

class LoginApp extends StatefulWidget {
  @override
  _LoginAppState createState() => _LoginAppState();
}

class ChoiceOfMenu {
  ChoiceOfMenu({this.title, this.icon});
  final String title;
  final IconData icon;
}

List<ChoiceOfMenu> choices = <ChoiceOfMenu>[
  new ChoiceOfMenu(title: ' Төсөл', icon: Icons.info),
//  new ChoiceOfMenu(title: 'Оролцох', icon: Icons.translate),
  new ChoiceOfMenu(title: ' Нутагшуулалт', icon: Icons.public),
  new ChoiceOfMenu(title: ' Нэвтрэх', icon: Icons.lock_open),
  new ChoiceOfMenu(title: ' Бүртгүүлэх', icon: Icons.fingerprint),
  new ChoiceOfMenu(title: ' Хэл солих', icon: Icons.language),
];

class _LoginAppState extends State<LoginApp> {
  final formKey = GlobalKey<FormState>();
  bool _validate = false;
  String _email, _password;
  ChoiceOfMenu _selectedChoice = choices[0];

  TextEditingController _controllerUsername = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  String label = languagesList[0];

  @override
  void initState() {
    super.initState();
  }

  void _select(ChoiceOfMenu choice) {
    if (choice.icon == Icons.info) {
      print("Tusuliin huudasruu orloo");
      Navigator.pushNamed(context, '/project');
    } else if (choice.icon == Icons.public) {
      print("Niitlel heseg ruu orloo");
      Navigator.pushNamed(context, '/guidelines');
    } else if (choice.icon == Icons.lock_open) {
      print("Nevtreh heseg ruu orloo");
      Navigator.pushNamed(context, '/');
    } else if (choice.icon == Icons.fingerprint) {
      print("burtguuleh heseg ruu orloo");
      Navigator.pushNamed(context, '/register');
    } else if (choice.icon == Icons.language) {
      print("hel solih");
    }

    setState(() {
      _selectedChoice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            "Нэвтрэх",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          actions: <Widget>[
            new InkWell(
              child: new PopupMenuButton<ChoiceOfMenu>(
                elevation: 3.2,
                initialValue: choices[1],
                onCanceled: () {
                  print('You have not chossed anything');
                },
                tooltip: 'This is tooltip',
                onSelected: _select,
                itemBuilder: (BuildContext context) {
                  return choices.map((ChoiceOfMenu choice) {
                    return PopupMenuItem<ChoiceOfMenu>(
                      value: choice,
                      child: Row(children: [
                        Icon(choice.icon),
                        Text(choice.title),
                      ]),
                    );
                  }).toList();
                },
              ),
            ),
          ],
        ),
        body: new Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("images/wallpaper.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            new Card(
              elevation: 5.0,
              margin: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 20.0, bottom: 90.0),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
                child: Form(
                    key: formKey,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.input, size: 36.0),
                                  Text(
                                    "НЭВТРЭХ",
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0,
                                    ),
                                  )
                                ]),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Хэрэглэгчийн нэр* ',
                              prefixIcon: Icon(Icons.person_outline),
                              errorText:
                                  _validate ? 'Value Can\'t Be Empty' : null,
                            ),
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            controller: _controllerUsername,
                            validator: (input) =>
                                !input.contains('@') && input.isEmpty
                                    ? 'Хэрэглэгчийн нэрээ оруулна уу'
                                    : null,
                            onSaved: (_controllerUsername) =>
                                _email = _controllerUsername,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Нууц үг* ',
                                prefixIcon: Icon(Icons.lock_outline)),
                            controller: _controllerPassword,
                            validator: (input) =>
                                input.length < 8 && input.isEmpty
                                    ? 'Нууц үгээ оруулна уу'
                                    : null,
                            onSaved: (input) => _password = input,
                            obscureText: true,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new InkWell(
                                  child: Padding(
                                    child: new Text('Нууц үгээ мартсан?'),
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/resetpass');
                                  },
                                ),
                              ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 10.0),
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  textColor: Colors.white,
                                  color: Colors.indigo,
                                  //onPressed: _submit,
                                  child: Text('Нэвтрэх'),
                                  onPressed: () {
                                    if (_controllerUsername.text != null &&
                                        _controllerUsername.text.length > 0) {
                                      print(_controllerUsername.text);
                                      _login(context, _controllerUsername.text,
                                          _controllerPassword.text);
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 10.0),
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  textColor: Colors.black,
                                  color: Colors.white,
                                  //onPressed: _submit,
                                  child: Text('Бүртгүүлэх'),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ])),
              ),
            )
          ],
        ));
  }

  void _login(context, username, password) {
    var url = "http://lkc.num.edu.mn/user/authenticate";
    http.post(url,
        body: jsonEncode({"username": username, "password": password}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }).then((response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      var respObj = jsonDecode(response.body);
      if (respObj['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', respObj['token']);
        //navigate to next
        Navigator.pushNamed(context, '/performance');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return RichAlertDialog(
                //uses the custom alert dialog
                alertTitle: richTitle('Хэрэглэгч олдсонгүй'),
                alertSubtitle: richSubtitle(""),
                alertType: RichAlertType.WARNING,
              );
            });
      }
    });
  }
}
