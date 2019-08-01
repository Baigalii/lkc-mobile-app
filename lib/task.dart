import 'package:flutter/material.dart';
import 'package:lkc/networklayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskApp extends StatefulWidget {
  @override
  _TaskAppState createState() => _TaskAppState();
}

class _TaskAppState extends State<TaskApp> with SingleTickerProviderStateMixin {
  TabController tabController;
  int currentPage;
  List synsetData = [];
  bool loading = true;
  List languages = [
    'eng',
    'deu',
    'fra',
    'rus',
    'zho',
    'jpn',
  ];

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 6, vsync: this);
    _taskNumber();
  }

  void _taskNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int type = prefs.getInt("taskNum");
    print("task ${type} ruu orloo");
    fetchTask(type).then((res) {
      setState(() {
        synsetData = res;
        print("synset length:");
        print(synsetData.length);
        synsetData = synsetData.map((synset) {
          synset['languageCodes'] = (synset['synset'] as List).map((_x) {
            return _x['languageCode'];
          }).toList();
          return synset;
        }).toList();
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: Text(
            "Нутагшуулах",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushNamed(context, '/performance'))),
      body: _buildBody(context),
      bottomNavigationBar: new Material(
        color: Colors.indigo,
        child: new TabBar(controller: tabController, tabs: <Widget>[
          new Tab(
            child:
                new Image(image: new AssetImage('images/united-kingdom.png')),
          ),
          new Tab(
            child: new Image(image: new AssetImage('images/germany.png')),
          ),
          new Tab(
            child: new Image(image: new AssetImage('images/france.png')),
          ),
          new Tab(
            child: new Image(image: new AssetImage('images/russia.png')),
          ),
          new Tab(
            child: new Image(image: new AssetImage('images/china.png')),
          ),
          new Tab(
            child: new Image(image: new AssetImage('images/japan.png')),
          ),
        ]),
      ),
    );
  }

  _buildBody(BuildContext context) {
    if (loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
          ],
        ),
      );
    } else {
      return TabBarView(
        controller: tabController,
        children: languages.map((x) {
          return new WordGridView(
            word: synsetData.where((synset) {
              return (synset['languageCodes'] as List).contains(x);
            }).toList(),
            code: x,
          );
        }).toList(),
      );
    }
  }
}

class WordGridView extends StatelessWidget {
  final List word;
  final String code;

  WordGridView({Key key, this.word, this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: word.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (BuildContext context, int index) {
        String lemma = '', gloss = '';
        List synset = word[index]['synset'] as List;
        for (var item in synset) {
          if (item['languageCode'] == code) {
            lemma = item['lemma'];
            gloss = item['gloss'];
            break;
          }
        }

        return new GestureDetector(
          onTap: () async {
            if (word[index]['available'] > 0) {
              int gid = word[index]['globalId'];
              SharedPreferences prefs = await SharedPreferences.getInstance();
              int type = prefs.getInt("taskNum");
              String taskId = word[index]['_id'];
              prefs.setInt("gid", gid);
              prefs.setString("taskID", taskId);
              print("global id:");
              print(gid);
              print("task id:");
              print(taskId);
              if (type == 1) {
                Navigator.pushNamed(context, '/allocate');
              } else if (type == 2) {
                Navigator.pushNamed(context, '/rearrange');
              } else if (type == 3) {
                Navigator.pushNamed(context, '/validate');
              } else if (type == 4) {
                Navigator.pushNamed(context, '/translate');
              } else if (type == 5) {
                Navigator.pushNamed(context, '/modify');
              } else if (type == 6) {
                Navigator.pushNamed(context, '/sort');
              }
            }
          },
          child: new Card(
            color: word[index]['available'] > 0 ? Colors.white : Colors.white70,
            elevation: 1.5,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        lemma ?? '-',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      new Text(gloss ?? '-'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
