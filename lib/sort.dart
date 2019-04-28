import 'package:flutter/material.dart';
import 'package:lkc/netwoklayer.dart';
import 'package:lkc/performance.dart';
import 'package:draggable_flutter_list/draggable_flutter_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Эрэмбэлэх

void main() => runApp(SortApp());

class SortApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Нүүр хэсэг',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Эрэмбэлэх'),
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
  double rating = 3.5;
  List sortWords = [];
  List modifiedGlosses = [];
  List language = [];
  String gloss = '', lemma = '';
  String _value = 'eng';
  List<Map> _values = [
    {'code': 'eng', 'label': 'English'},
    {'code': 'fra', 'label': 'French'},
    {'code': 'zho', 'label': 'Chinese'},
    {'code': 'jpn', 'label': 'Japanese'}
  ];
  List items = [];

  void initState() {
    super.initState();
    _showSort();
  }

  _showSort() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int gid = prefs.getInt("gid");
    fetchSort(gid).then((res) {
      setState(() {
        try {
          if(res['languageCode']==0){
            gloss = 'Энэ айд зориулж ямар нэг даалгавар генераци хийгээгүй эсвэл бүх даалгаврууд хийгдэж дууссан байна. Өөр айд шилжинэ үү.';
          } else {
            sortWords = res['task']['synset'];
            modifiedGlosses = res['task']['modifiedGlosses'];
            var t = res['task']['synset'] as List;
            var codes = t.map((x) {
              return x['languageCode'];
            }).toList();
            language = codes;
            print("Revise words:");
            print(res['task']['synset']);
            for(var i in sortWords){
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
          )),
      body: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: new Text(
              'Доорх өгүүлбэрүүдийг ойлголтын тайлбарыг хэр оновчтой орчуулснаар эрэмбэлнэ үү!',
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
//                      new Icon(Icons.language),
                    _langIcon(value['code'].toString()),
                      new Text('  ${value['label']}'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value){
                for(var item in sortWords){
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
                  fontWeight: FontWeight.bold,),
                ),
                Text(gloss.toLowerCase(), style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),),
              ],
            ),
          ),
          Expanded(
            child: DragAndDropList(
              modifiedGlosses.length,
              itemBuilder: (BuildContext context, index) {
                return new SizedBox(
                  child: new Card(
                    child: new ListTile(
                      title: new Text(modifiedGlosses[index]['gloss']),
                    ),
                  ),
                );
              },
              onDragFinish: (before, after) {
                print(before);
                print(after);
                setState(() {
                  print('on drag finish $before $after');
                  String data = modifiedGlosses[before]['gloss'];
                  modifiedGlosses.removeAt(before);
                  modifiedGlosses.insert(after, data);
                });
              },
              canDrag: (index) {
                print('can drag $index');
                return index != 3; //disable drag for index 3
              },
              canBeDraggedTo: (one, two) => true,
              dragElevation: 5.0,
            ),
          ),
          Divider(
            height: 25.0,
          ),
          Row(
            children: <Widget>[
            Padding(
                  padding: EdgeInsets.only(left: 10.0),
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
                  padding: EdgeInsets.only(left: 150.0, right: 10.0),
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
    );
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
