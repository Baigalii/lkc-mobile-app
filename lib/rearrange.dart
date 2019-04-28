import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lkc/netwoklayer.dart';
import 'package:lkc/performance.dart';
import 'package:lkc/synset.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//Засварлах
void main() => runApp(RearrangeApp());

class RearrangeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Нүүр хэсэг',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Засварлах'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _words = [];
  List<TextEditingController> _controllers = [];

//  TextEditingController _controllerModified = new TextEditingController();
  List<TextEditingController> _controllerModified = [];
  List rearrangeWords = [];
  List translatedWords = [];
  List language = [];
  double rating = 3.5;

  String gloss = '', lemma = '';
  String _value = 'eng';
  List<Map> _values = [
    {'code': 'eng', 'label': 'English'},
    {'code': 'zho', 'label': 'Chinese'},
    {'code': 'deu', 'label': 'Deutsch'},
    {'code': 'fra', 'label': 'French'},
    {'code': 'rus', 'label': 'Russian'},
    {'code': 'jpn', 'label': 'Japanese'},
  ];

  void initState() {
    super.initState();
    _showModification();

  }

  _showModification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int gid = prefs.getInt("gid");
    fetchModification(gid).then((res) {
      setState(() {
        try {
          if(res['statusCode']==0){
            gloss = 'Энэ айд зориулж ямар нэг даалгавар генераци хийгээгүй эсвэл бүх даалгаврууд хийгдэж дууссан байна. Өөр айд шилжинэ үү.';
          } else {
            rearrangeWords = res['task']['synset'];
            translatedWords = res['task']['translatedWords'];
            var t = res['task']['synset'] as List;
            var codes = t.map((x) {
              return x['languageCode'];
            }).toList();
            language = codes;
            print("Modification words:");
            print(res['task']['synset']);
            for(var i in rearrangeWords){
              if(i['languageCode']==_value){
                lemma = i['lemma'];
                gloss = i['gloss'];
              }

            }
          }
        } catch (e) {
          print(e);
        }
      });
    });
  }

  void _onChanged(String value){
    setState(() {
      _value = value;
    });
  }
//  void _modifiedWord(String word) {
//    setState(() {
//
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () =>  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PerformanceApp()),
            ),
          )
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: (){
//          setState(() {
//            _words.add('');
//            _controllers.add(TextEditingController());
//          });
//        },
//        child: Icon(Icons.add),
//      ),
      body: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: new Text(
                'Дараах ойлголтыг илэрхийлэх монгол үг(с)ийн алдааг засах эсвэл алдаатай үгсийг хасна уу',
                style: new TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
            Divider(
              height: 10.0,
            ),
            Center(
              child: DropdownButton(
                value: _value,
                items: _values.where((x){
                  return language.contains(x['code']);
                }).map((value){
                  return new DropdownMenuItem(
                    value: value['code'],
                    child: new Row(
                      children: <Widget>[
                        _langIcon(value['code'].toString()),
//                        new Icon(Icons.language),
                        new Text('  ${value['label']}'),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value){
                  for(var item in rearrangeWords){
                    if(item['languageCode']==value){
                      lemma = item['lemma'];
                      gloss = item['gloss'];
                    }
                  }
                  _onChanged(value);
                },

              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(lemma.toLowerCase(), style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                    
                  ),
                  Text(gloss.toLowerCase(), style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),),
                ],
              ),
            ),
            Divider(
              height: 10.0,
            ),
            Column(
              children: _buildWords(context),
            ),
            Divider(
              height: 25.0,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: new FlatButton(
                    onPressed: () => {},
                    padding: EdgeInsets.all(10.0),
                    child: Row( // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Text("GAP", style: TextStyle(color: Colors.indigo),),
                        Icon(Icons.event_busy, color: Colors.indigo,)
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 55.0),
                  child: new  FlatButton(
                    onPressed: () => {},
                    padding: EdgeInsets.all(10.0),
                    child: Row( // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Text("Алгасах", style: TextStyle(color: Colors.indigo),),
                        Icon(Icons.skip_next, color: Colors.indigo,)
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 5.0),
                  child: new FlatButton(
                    onPressed: () => {},
                    padding: EdgeInsets.all(10.0),
                    child: Row( // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Text("Илгээх", style: TextStyle(color: Colors.indigo),),
                        Icon(Icons.send, color: Colors.indigo,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  _buildWords(BuildContext context) {
    var children = <Widget>[];
    for (var i=0; i < translatedWords.length; i++) {
      var controller = new TextEditingController();
      var controllerModified = new TextEditingController();
//      controllerModified.text = '';
      controller.text = translatedWords[i]['word'];
      children.add(Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: new TextField(
               enabled: false,
                decoration: InputDecoration(
                  labelText: '',
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                controller: controller,
              ),
            ),

          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: new TextField(
                    decoration: InputDecoration(
                      suffix:  IconButton(
                        icon: Icon(Icons.spellcheck),
                          onPressed: (){
                            print('spellcheck pressed');
                            print(controllerModified.text = translatedWords[i]['word']);
                            controllerModified.text = translatedWords[i]['word'];
                          },
                      ),
                      fillColor: Colors.blueAccent,
                      labelText: '',
                      hintText: 'Засвар үг',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    controller: controllerModified,
                ),
                )
              ),
              IconButton(
                  padding: EdgeInsets.only(left: 20.0, right: 20),
                  color: Colors.red,
                  icon: Icon(Icons.remove_circle),
                  alignment: Alignment.bottomLeft,
                  onPressed: () {
                    setState(() {
                      print(i);
                      _words.removeAt(i);
                      _controllers.removeAt(i);
                    });
                  },
                ),
            ],
          ),
        ],
      ));
    }
    return children;
  }
}

_langIcon(String value) {
  if(value=='eng'){
    return new Image(image: new AssetImage('images/united-kingdom.png'), width: 25, height: 25,);
  } else if(value=='zho'){
    return new Image(image: new AssetImage('images/china.png'), width: 25, height: 25,);
  } else if(value=='deu'){
    return new Image(image: new AssetImage('images/germany.png'), width: 25, height: 25,);
  } else if(value=='fra'){
    return new Image(image: new AssetImage('images/france.png'), width: 25, height: 25,);
  } else if(value=='rus'){
    return new Image(image: new AssetImage('images/russia.png'), width: 25, height: 25,);
  } else if(value=='jpn'){
    return new Image(image: new AssetImage('images/japan.png'), width: 25, height: 25,);
  }
}

