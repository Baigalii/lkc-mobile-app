import 'package:flutter/material.dart';

class GuidelineApp extends StatefulWidget {
  @override
  _GuidelineAppState createState() => _GuidelineAppState();
}

class _GuidelineAppState extends State<GuidelineApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Нутагшуулалт",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushNamed(context, '/')),
        ),
        body: new SingleChildScrollView(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0, top: 20.0, left: 20.0),
                child: new Text(
                  'нутагшуулах ажил'.toUpperCase(),
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                height: 25.0,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: new Text(
                    "Нутагшуулах ажил нь олон хэл дээр илэрхийлэгдсэн ойлголтыг "
                    "Монгол хэл рүү буулгахад хэрэгжүүлж байгаа үйл ажиллагаануудыг цогцоор нь нэрлэнэ. ",
                    textAlign: TextAlign.justify),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: new Image(
                    image: new AssetImage("images/ont_localization.png")),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: new Text(
                    "Нутагшуулах үйл ажиллагаанд таны зүгээс оруулах "
                    "хувь нэмэр нь гурван төрөлд ангилагдана. Өөрөөр хэлбэл, "
                    "та ойлголтыг орчуулах, засварлах болон үнэлэх даалгавруудыг"
                    " хүссэнээрээ сонгон гүйцэтгэж болно. ",
                    textAlign: TextAlign.justify),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: new Image(image: new AssetImage("images/ss_task.jpg")),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: new Text(
                  'Даалгаврын төрлөөс үл хамааран танд 25 ай (domain) өгөгдөнө. '
                  'Энэ 25 ай нь бүх нэр үгийн ойлголтуудын үндэс бөгөөд ай тус бүр тухайн '
                  'ойлголтоос ургаж гарсан ойлголтуудыг агуулж байдаг. Иймд аливаа айг сонгосноор, '
                  'та тэр ойлголттой холбоотой ойлголтуудыг орчуулах ба хэдий чинээ ихийг орчуулна '
                  '(эсвэл засварлах, үнэлэх) төдий чинээ төрөл ойлголтуудын ялгааг гаргаж орчуулах '
                  '(эсвэл засварлах, үнэлэх) чадвар шаардагдах юм. ',
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: new Image(image: new AssetImage("images/ss_domain.jpg")),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: new Text(
                    "Үүний дараагаар таны ямар даалгавар сонгосноос хамааран, "
                    "систем таны гүйцэтгэх даалгаврыг бэлтгэж өгнө.",
                    textAlign: TextAlign.justify),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: new ExpansionTile(
                  title: new Text("Орчуулах"),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new Text(
                          "Та орчуулах ажлаар, өгөгдсөн ойлголтыг илэрхийлэх ойролцоо үгсийг орчуулна. "
                          "Тухайн ойлголтыг илэрхийлэхэд Монгол хэл соёлд маань ашиглагддаг өөрийн мэдэх үгсийг оноож, "
                          "та үүндээ хэр итгэл дүүрэн байгаа хувийн үнэлгээгээ мөн оноож өгнө.",
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new Image(
                          image: new AssetImage("images/ss_translation.jpg")),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new Text(
                          "Хэрвээ ойлголт Монгол хэлэнд оршдог гэж үзвэл дор хаяж нэг үгтэй байх ёстой. "
                          "Харин Монгол хэлэнд тухайн ойлголт байхгүй гэж үзвэл GAP сонголтыг сонгон яагаад энэ "
                          "ойлголт Монгол хэлэнд байдаггүй тайлбарыг хангаж өгөх хэрэгтэй.",
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new Image(
                          image: new AssetImage("images/gap_translation.jpg")),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new Text(
                          'Жишээлбэл, Англи хэлэнд "brother" гэсэн ойлголт нь эрэгтэй дүү юм уу ахыг нэрлэдэг. '
                          'Харин манай хэлний хувьд насны хэмжээстээр ангилан "ах", "дүү" гэсэн ойлголтуудад хуваагддаг. '
                          'Хэрвээ танд өмнө орчуулсан үр дүн чинь одоогийн орчуулгад хэрэгтэй болвол "ӨМНӨ НЬ" гэсэн картыг дарахад хангалттай. ',
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new Image(
                          image: new AssetImage("images/prev_translation.jpg")),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new Text(
                          'Өмнө орчуулсан ойлголтуудаа "өмнөх" ба "дараах" гэсэн товчуудаар сольж үзэж болно. ',
                          textAlign: TextAlign.justify),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: new ExpansionTile(
                  title: new Text("Засварлах"),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new Text(
                        "Та засварын даалгаврын хүрээнд дараах 2 зорилгыг гүйцэлдүүлэх хэрэгтэй: "
                        "\n\nХэрвээ тухайн ойлголтод харьяалагдахгүй, эсвэл тохиромжгүй үг байвал хасах "
                        "\nХэрвээ тухайн ойлголтод харьяалагдахад зохимжтой үг сангийн алдаатай бичигдсэн бол засах ",
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child:
                          new Image(image: new AssetImage("images/ss_mod.jpg")),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new Text(
                          "Ойлголтод оноогдсон байгаа үг бүрийн хувьд 2 товч байгаа."
                          " Хэрвээ үг уг ойлголтыг төлөөлж чадна, мөн үгийн сангийн алдаагүй "
                          "бичигдсэн гэж үзвэл хэвээр үлдээх (spellcheck) товчийг ашиглана. "
                          "Хэрвээ үг уг ойлголтыг төлөөлж чадаж байгаа хэдий ч үгийн сангийн "
                          "алдаатай бичигдсэн бол харгалзах 'засвар үг' дээр алдаагүй хувилбарыг нь бичиж өгнө."
                          " Харин үг нь тухайн ойлголтыг илэрхийлэхэд тохиромжгүй гэж үзвэл арилгах товчоор (clear) хасна. ",
                          textAlign: TextAlign.justify),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: new ExpansionTile(
                  title: new Text("Үнэлэх"),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new Text(
                          "Та үнэлгээний даалгавраар өгөгдсөн үгс, харгалзах ойлголтынхоо үгс мөн,"
                          " биш эсэхийг үг тус бүрийн хувьд сонгож өгөх юм. Эргэлзээтэй тохиолдолд мэдэхгүй сонголт байгаа.",
                          textAlign: TextAlign.justify),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new Image(
                          image: new AssetImage("images/ss_valid.jpg")),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
