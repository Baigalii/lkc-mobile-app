import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lkc/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lkc/performance.dart';

void main() => runApp(RegisterApp());

class RegisterApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: ''),

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//List<CustomPopupMenu> choices = <CustomPopupMenu>[
//  CustomPopupMenu(title: ' Төсөл', icon: Icons.info),
//  CustomPopupMenu(title: ' Оролцох', icon: Icons.translate),
//  CustomPopupMenu(title: ' Нийтлэл', icon: Icons.public),
//  CustomPopupMenu(title: ' Нэвтрэх', icon: Icons.lock_open),
//  CustomPopupMenu(title: ' Бүртгүүлэх', icon: Icons.fingerprint),
//];

class _MyHomePageState extends State<MyHomePage> {
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
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginApp()),
            ),
          ),
          backgroundColor: Colors.indigo,
          actions: <Widget>[
          ],
        ),
        body: new Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("images/wallpaper.jpg"), fit: BoxFit.cover,),
              ),
            ),
            new Card(
              elevation: 5.0,
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 90.0),
              child:Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
                child: Form(
                    key: formKey,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.fingerprint, size: 36.0),
                                  Text('БҮРТГҮҮЛЭХ',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0,),
                                  )
                                ]),
                          ),
                          Row(
                            children: <Widget>[
                              Text('доорх шаардлагатай мэдээллүүдийг бөглөнө үү.', style: TextStyle(fontSize: 11.0, color: Colors.black38), ),
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
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Өөрийн нэр* '), //InputDecoration
                            validator: (input) =>
                            !input.contains('@') ? 'Нэрээ оруулна уу' : null,
                            onSaved: (input) => _name = input,
                            controller: _controllerName,
                          ),

                          TextFormField(
                            decoration: InputDecoration(labelText: 'И-Мэйл хаяг* '), //InputDecoration
                            validator: (input) =>
                            !input.contains('@') ? 'Хүчинтэй и-мэйл хаягаа оруулна уу' : null,
                            onSaved: (input) => _email = input,
                            controller: _controllerEmail,
                          ),

                          TextFormField(
                            decoration: InputDecoration(labelText: 'Нууц үг* '),
                            validator: (input) =>
                            input.length < 8 ? 'Нууц үгээ оруулна уу' : null,
                            onSaved: (input) => _password = input,
                            obscureText: true,
                            controller: _controllerPassword,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new InkWell(
                                child: new Text('нэвтрэх үү?'),
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginApp()),
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
                                    if (_controllerUsername.text.length >= 4 && _controllerName.text.length >= 2 &&
                                    _controllerEmail.text.length != null && _controllerPassword.text.length >= 6) {
                                      print(_controllerUsername.text);
                                      print(_controllerName.text);
                                      print(_controllerEmail.text);
                                      print(_controllerPassword.text);
                                      _register(context, _controllerUsername.text, _controllerName.text, _controllerEmail.text, _controllerPassword.text);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ]
                    )
                ),
              ),
            )
          ],
        )
    );
  }

//  void _select(CustomPopupMenu choice) {
//    setState(() {
//      _selectedChoices = choice;
//    });
//  }

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
    http.post(url, body: jsonEncode({"username": username,
      "name": name,
      "email": email,
      "password": password}), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    })
        .then((response) async {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      var respObj = jsonDecode(response.body);
      if (respObj['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', respObj['token']);
        //success
        //navigate to home
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginApp()),
        );
      }
    });
  }
}
