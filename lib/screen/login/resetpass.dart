import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResetApp extends StatefulWidget {
  @override
  _ResetAppState createState() => _ResetAppState();
}

class _ResetAppState extends State<ResetApp> {
  TextEditingController _controllerName = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            title: Text(
              "Нууц үг сэргээх",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pushNamed(context, '/'))),
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
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock, size: 36.0),
                              Text(
                                'Нууц үг өөрчлөх',
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              )
                            ]),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Хэрэглэгчийн нэр* '), //InputDecoration
                        validator: (input) => !input.contains('@')
                            ? 'Хэрэглэгчийн нэрээ оруулна уу'
                            : null,
//                           onSaved: (input) => _ = input,
                        controller: _controllerName,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: RaisedButton(
                            padding: const EdgeInsets.all(10.0),
                            textColor: Colors.white,
                            color: Colors.blue,
                            //onPressed: _submit,
                            child: Text('Илгээх'),
                            onPressed: () {
                              print(_controllerName.text);
                              _resetpass(context, _controllerName.text);
                            }),
                      )
                    ])),
              ),
            )
          ],
        ));
  }

  void _resetpass(context, name) {
    var url = "http://lkc.num.edu.mn/user/reset";
    http.post(url, body: jsonEncode({"username": name}), headers: {
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
