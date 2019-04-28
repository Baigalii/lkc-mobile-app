import 'package:flutter/material.dart';
import 'package:lkc/guidelines.dart';
import 'package:lkc/login.dart';


void main() => runApp(ProjectApp());

class ProjectApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Нүүр хэсэг',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Төсөл'),
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginApp()),
            ),
          ),
        ),
        body: new SingleChildScrollView(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0, top: 20.0, left: 20.0),
                child: new Text("mongolian lkc".toUpperCase(),
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.justify),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                child: new Text("(Монгол Нутгийн Мэдлэгийн Цөмийг үүсгэх төслийн тухайд)",
                    style: TextStyle(fontSize: 15.0),
                    textAlign: TextAlign.justify),
              ),
              Divider(
                height: 25.0,
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
                child: new Text("агуулга".toUpperCase(),
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0, left: 20.0, top:10.0 ),
                child: new Text(" Оршил"
                    "\n\n Төслийн тухай"
                    "\n\n Холбоо барих",
                    style: TextStyle(fontSize: 15.0),
                    textAlign: TextAlign.justify),
              ),
              Divider(
                height: 25.0,
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
                child: new Text("оршил".toUpperCase(),
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0),
                child: new Text('   Таны хэрэглэж байгаа аппликейшн таны оруулсан өгөгдлийг утгачлан задлаж ойлгоод, '
                    'ойлгосон санаагаараа хайлт хийгээд зогсохгүй өөр эх сурвалжуудаас ухаж олсон өгөгдлүүдээ '
                    'тодорхой нэг хэлбэрт хэлбэршүүлж нэгтгээд эсвэл холбоод гаргаж үзүүлдэг үйлчилгээтэй бол '
                    'гар ажиллагааг хэдий чинээ хөнгөвчилнө гэж төсөөлөгдөж байна даа?'
                '\n\n   Та бид өсөж төрсөн цагаасаа эхлэн юмсыг бас юмсын учир зүйн холбоог таньж мэдэж ирсэн учраас'
                    'хүлээн авч байгаа мэдээлэлдээ дүгнэлт хийн, түүнээсээ шийдвэр гаргах чадварыг аль хэдийн эзэмшсэн байдаг. '
                    'Харин машины хувьд ямар бол?'
                '\n\nДараах жишээг авч үзье л дээ:'
                '\n\nАмьтан бол гартай хөлтэй.'
                '\n\nМахан тэжээлтэн ба өвсөн тэжээлтэн нь энэ төрөлд ордог.'
                '\n\nМахчин нь өвсөн тэжээлтнээ иддэг.'
                '\n\nЧоно бол махан тэжээлтэн.'
                '\n\nХонь бол өвсөн тэжээлтэн.'
                '\n\nЭнэ бол та бидний харж сонсож мэдсэн хоолны гинжин системийн (food chain system)'
                    'хүрээнд яригдах логикийн өчүүхэн нэг хэсэг нь. Бид энэ логикийг төвөггүй ойлгоод '
                    '"хоттой хонио чоноос хамгаалах хэрэгтэй" гэсэн дүгнэлтэд хүрч болох ч чоно, хонь, '
                    'амьтан гэх мэт ойлголтуудыг мэддэггүй байсан бол уг логикийг ашиглаж чадах байсан'
                    'эдэг нь мөн эргэлзээтэй.Тэгвэл машины хувьд ч ижил хэрэг. '
                    , textAlign: TextAlign.justify),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: new Image(
                    image: new AssetImage("images/ontology.png")),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0),
                child: new Text("     Бид орчлон хорвоо дээр өөрсдийн мэдрэхүйгээрээ хүлээн авч,"
                    " ойлгодог тэрхүү ойлголтуудаа машинд ойлгуулсан цагт сая бид чанартай семантик "
                    "үйлчилгээг ярьж эхлэх юм. Дээрх зурагт өмнө дурьдсан ойлголтууд ба тэдгээрийн "
                    "холбоог дүрсэлснийг онтологи гэж нэрлээд, компьютерт OWL хэлээр загварчилдаг. "
                    "Дугуй тэмдэглэгээтэй нь ойлголт буюу энэ нь ямар ч хэлэнд харьяалагдахгүй, "
                    "гагцхүү ертөнц дээр байгаа зүйлийг (хийсвэл эсвэл бодит) илэрхийлдэг заалт юм. "
                "\n\n    Иймд бид танд Монгол хэлний нөөцийг агуулах Нутгийн Мэдлэгийн Цөмийг (НМЦ) танилцуулж байна. "
                    "Энэ бол бидний хэл соёлд идээшсэн ойлголтуудын нэршлийг агуулах мэдлэгийн сан юм. "
                    "Мэдээж бусад хэлний НМЦ ч гэсэн тухайн соёлынхоо ойлголтуудын нэршлийг агуулж байдаг. ",
                    textAlign: TextAlign.justify),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: new Image(
                    image: new AssetImage("images/lkc.png")),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0),
                child: new Text("     Жишээлбэл, дээрх зурагт бидний хэлж заншсан тоглоом гэдэг үг нь 2 утга "
                    "(нэг нь хүүхдийн тоглодог тоглоом, нөгөө нь дүрэмтэй тэмцээн) илэрхийлдэг, утгууд "
                    "нь тус тусдаа оршиж байдаг бол Англи хэлэнд тус бүрт нь зориулсан (toy, game) үгс байдаг."
                    " Өөр нэг жишээ үзвэл, монгол гэр гэдэг ойлголт оршдог хэдий ч зөвхөн Монгол НМЦ-д байх "
                    "агаад бусад НМЦ-д оршихгүй юм. Учир нь энэ нь зөвхөн Монгол соёлд маань байдаг өвөрмөц "
                    "ойлголт учраас тэр. Энэ зарчмаар хэлний ялгаатай байдлууд үүсдэг нь хэл тус бүрт НМЦ"
                    " үүсгэх анхдагч шалтгаан болжээ.", textAlign: TextAlign.justify
                ),
              ),
              Divider(
                height: 25.0,
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0),
                child: new Text("төслийн тухай".toUpperCase(),
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0),
                child: new Text('     Бид энэ төслийн ажлаар Монгол НМЦ-ийг олны хүчээр үүсгэх зорилготой байгаа. '
                    'Ертөнцийн ойлголтуудын логик уялдаа холбоо нь хэлнээс хамаарахгүйгээр оршдог бөгөөд '
                    'олон хэл дээр загварчлагдсан байдаг. Ойлголтуудыг тэдгээр хэлүүдээс Монгол хэл рүү '
                    'орчуулах замаар нутагшуулах аргачлалыг турших зорилгоор энэ системийг ашиглаж байгаа билээ.'
                '\n\n     Нэг ойлголтыг бид ойролцоо утгатай үгсээр илэрхийлдэг. '
                    'Жишээлбэл: "аав, эцэг", "анчин, гөрөөчин, ангууч" гэх мэт.', textAlign: TextAlign.justify),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: new Image(
                    image: new AssetImage("images/localization.png")),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0),
                child: new Text("     Системийн үйл ажиллагаа нь олны хүчийг ашиглан Монгол хэл дээрх ойлголтуудыг"
                    " гаргаж авах гурван фазаас тогтоно:"
                    "\n\n 1. Орчуулах - Энэ фазд оролцогч олон хэлээр илэрхийлсэн ойлголтод тохирох монгол үгийг оноож бичнэ"
                    "\n\n 2. Засварлах - Энэ фазд оролцогч ойлголтод тохирох монгол үгийн алдааг засна (тохиромжгүй үгийг хасах,"
                    " алдаатай бичигдсэн үгийг засах)"
                    "\n\n 3. Үнэлэх - Энэ фазд оролцогч ойлголтыг оновчтой илэрхийлж байгаа үгсийг зөв, буруугаар нь ангилна."
                    "\n\n    Энэ хэсэг нь танд манай төслийн ерөнхий зорилго бөгөөд аргачлалын тухай товчхон танилцуулах "
                    "зорилготой байсан бөгөөд даалгавруудыг хэрхэн гүйцэтгэх талаар дэлгэрэнгүйг нутагшуулах хэсгээс тодруулна уу."
                    "\n\n    Эцсийн эцэст Монгол мэдлэгийг компьютерт оруулж машиныг Монгол мэдлэгтэй болгох нь бидний судалгааны ажлын туйлын зорилго. "
                    "Энэ мэдлэг даяаршиж буй дэлхийд Монгол соёлыг хадгалж ирээдүй хойч үедээ өвлүүлэх, эх хэл соёлоороо зөв сэтгэж ярьж "
                    "сурахад дэмжлэг үзүүлэх, компьютер дээрх монгол хэлний нөөцийг баяжуулах зэрэг нь онц ач холбогдолтой аж. "
                    "Ирээдүйд оюунлаг машинууд хоорондоо харилцаж хүний амьдралд тусалдаг болох тэр үед Монгол улсыг бэлэн байлгах,"
                    " Монгол машин бусад орны машинуудтай улсаа төлөөлөн харилцан ажиллахад суурь мэдлэг болно."
                    "\n\n    Таны оруулж буй хувь нэмэрт бид гүнээ талархаж байна!\n", textAlign: TextAlign.justify),
              ),
              Divider(
                height: 25.0,
              ),
            ],

          ),
        )
    );
  }
}
