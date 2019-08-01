import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lkc/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterApp extends StatefulWidget {
  @override
  _RegisterAppState createState() => _RegisterAppState();
}

class _RegisterAppState extends State<RegisterApp> {
  final formKey = GlobalKey<FormState>();
  String _email, _uname, _password, _name;
//  CustomPopupMenu _selectedChoices = choices[0];
  TextEditingController _controllerUsername = new TextEditingController();
  TextEditingController _controllerName = new TextEditingController();
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            "Бүртгүүлэх",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushNamed(context, '/')),
          backgroundColor: Colors.indigo,
          actions: <Widget>[],
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
                    child: Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fingerprint, size: 36.0),
                              Text(
                                'БҮРТГҮҮЛЭХ',
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              )
                            ]),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'доорх шаардлагатай мэдээллүүдийг бөглөнө үү.',
                            style: TextStyle(
                                fontSize: 11.0, color: Colors.black38),
                          ),
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Хэрэглэгчийн нэр* '), //InputDecoration
                        validator: (input) => !input.contains('@')
                            ? 'Хэрэглэгчийн нэрээ оруулна уу'
                            : null,
                        onSaved: (input) => _uname = input,
                        controller: _controllerUsername,
                        keyboardType: TextInputType.text,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Өөрийн нэр* '), //InputDecoration
                        validator: (input) =>
                            !input.contains('@') ? 'Нэрээ оруулна уу' : null,
                        onSaved: (input) => _name = input,
                        controller: _controllerName,
                        keyboardType: TextInputType.text,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'И-Мэйл хаяг* '), //InputDecoration
                        validator: (input) => !input.contains('@')
                            ? 'Хүчинтэй и-мэйл хаягаа оруулна уу'
                            : null,
                        onSaved: (input) => _email = input,
                        controller: _controllerEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Нууц үг* '),
                        validator: (input) =>
                            input.length < 8 ? 'Нууц үгээ оруулна уу' : null,
                        onSaved: (input) => _password = input,
                        obscureText: true,
                        controller: _controllerPassword,
                        keyboardType: TextInputType.text,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new InkWell(
                            child: new Text('нэвтрэх үү?'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginApp()),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: RaisedButton(
                              padding: const EdgeInsets.all(10.0),
                              textColor: Colors.white,
                              color: Colors.indigo,
                              //onPressed: _submit,
                              child: Text('Бүртгүүлэх'),
                              onPressed: () {
                                if (_controllerUsername.text.length >= 4 &&
                                    _controllerName.text.length >= 2 &&
                                    _controllerEmail.text.length != null &&
                                    _controllerPassword.text.length >= 6) {
                                  print(_controllerUsername.text);
                                  print(_controllerName.text);
                                  print(_controllerEmail.text);
                                  print(_controllerPassword.text);
                                  _register(
                                      context,
                                      _controllerUsername.text,
                                      _controllerName.text,
                                      _controllerEmail.text,
                                      _controllerPassword.text);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ])),
              ),
            )
          ],
        ));
  }

  void _submit() {
    if (formKey.currentState.validate()) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Processing Data')));
      setState(() {
        formKey.currentState.save();
        //Navigator.push(context, LoginApp());
      });

      print(_email);
      print(_password);
    }
  }

  void _register(context, username, name, email, password) {
    var url = "http://lkc.num.edu.mn/user/register";
    http.post(url,
        body: jsonEncode({
          "username": username,
          "name": name,
          "email": email,
          "password": password
        }),
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
        //success
        //navigate to home
        Navigator.pushNamed(context, '/');
      }
    });
  }
}
