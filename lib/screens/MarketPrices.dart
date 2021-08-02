import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_scraper/web_scraper.dart';

class MarketPrices extends StatefulWidget {
  @override
  _MarketPricesState createState() => _MarketPricesState();
}

class _MarketPricesState extends State<MarketPrices> {
  WebScraper webScraper;
  bool loaded = false;
  String marketPrice;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Widget LoadingScreen() {
    return Scaffold(
      body: Center(
        child: SpinKitRotatingCircle(
          color: Color(0xff322C40),
          size: 40.0,
        ),
      ),
    );
  }

  var list = [
    "Mombasa	124.72	105.27	95.46",
    "Kilifi	125.43	105.98	96.17",
    "Likoni Mainland	125.07	105.62	95.82",
    "Kwale	125.07	105.62	95.82",
    "Malindi	125.64	106.19	96.38",
    "Lungalunga	125.79	106.34	96.53",
    "Voi	126.20	106.75	96.93",
    "Taveta	127.60	108.15	98.34",
    "Lamu	128.02	108.57	98.76",
    "Hola	128.30	108.85	99.05",
    "Nairobi	127.14	107.66	97.85",
    "Thika	127.15	107.66	97.85",
    "Machakos	127.38	107.89	98.08",
    "Kajiado	127.56	108.08	98.26",
    "Makuyu	127.43	107.95	98.13",
    "Muranga	127.66	108.18	98.37",
    "Sagana	127.88	108.40	98.58",
    "Embu	128.24	108.77	98.95",
    "Kerugoya	128.16	108.68	98.87",
    "Narok	128.53	109.05	99.23",
    "Nyeri	128.51	109.04	99.22",
    "Namanga	128.68	109.20	99.38",
    "Kiganjo	128.48	108.99	99.18",
    "Chuka	128.77	109.30	99.48",
    "Kitui	128.67	109.19	99.37",
    "Mwingi	129.06	109.58	99.76",
    "Nanyuki	129.07	109.59	99.77",
    "Nkubu	130.04	110.56	100.74",
    "Mtito Andei	129.58	110.10	100.28",
    "Meru	130.24	110.75	100.94",
    "Isiolo	130.10	110.61	100.80",
    "Maua	130.69	111.21	101.39",
    "Garissa	131.31	111.82	102.02",
    "Marsabit	134.99	115.52	105.70",
    "Liboi	134.07	114.60	104.78",
    "Moyale	136.57	117.09	107.28",
    "Sololo	135.63	116.14	106.33",
    "Habaswein	134.00	114.51	104.71",
    "Dadaab	132.69	113.21	103.40",
    "Tarbaj	136.25	116.77	106.95",
    "Elwak	137.85	118.37	108.55",
    "Wajir	136.40	116.92	107.10",
    "Modogashe	134.14	114.66	104.85",
    "Mandera	140.18	120.70	110.88",
    "Nakuru	126.75	107.55	97.76",
    "Gilgil	126.72	107.51	97.72",
    "Mogotio	126.71	107.49	97.71",
    "Molo	126.79	107.59	97.80",
    "Olenguruone	127.49	108.29	98.50",
    "Londiani	127.01	107.81	98.02",
    "Nyahururu	127.00	107.79	98.01",
    "Archers Post	129.99	110.79	101.00",
    "Lodosoit	131.08	111.88	102.09",
    "Naivasha	127.07	107.87	98.09",
    "Marigat	127.47	108.27	98.49",
    "Kabarnet	127.97	108.77	98.98",
    "Maralal	129.05	109.85	100.06",
    "Eldoret	127.67	108.46	98.68",
    "Kiplombe	127.67	108.46	98.68",
    "Iten	127.67	108.46	98.68",
    "Naiberi	127.67	108.46	98.68",
    "Kesses	127.67	108.46	98.68",
    "Kapsabet	127.69	108.49	98.70",
    "Webuye	128.10	108.90	99.11",
    "Kitale	128.03	108.83	99.05",
    "Kapenguria	128.67	109.47	99.68",
    "Bungoma	128.43	109.23	99.45",
    "Moiben	127.69	108.49	98.70",
    "Matunda	127.66	108.45	98.67",
    "Burnt Forest	127.62	108.42	98.64",
    "Tambach	127.71	108.51	98.72",
    "Kapsowar	128.17	108.97	99.19",
    "Chebara	128.06	108.85	99.07",
    "Kimwarer	127.98	108.78	98.99",
    "Timboroa	127.90	108.70	98.92",
    "Nandi Hills	127.86	108.66	98.87",
    "Kaiboi	127.72	108.52	98.73",
    "Kiminini	128.22	109.01	99.23",
    "Endebes	128.56	109.36	99.58",
    "Saboti	128.24	109.04	99.25",
    "Chepareria	128.88	109.67	99.89",
    "Lomut	130.50	111.28	101.50",
    "Burgich	129.29	110.08	100.30",
    "Sigor	129.42	110.21	100.43",
    "Lowdar	131.85	112.64	102.86",
    "Kakuma	133.44	114.24	104.45",
    "Lokichar	130.85	111.65	101.87",
    "Kalokol	132.61	113.41	103.63",
    "Lokori	131.22	112.02	102.22",
    "Lokitaung	135.50	116.29	106.51",
    "Kapedo	130.50	111.28	101.50",
    "Malaba	128.83	109.63	99.85",
    "Lokichogio	134.63	115.43	105.65",
    "Ziwa	127.86	108.66	98.87",
    "Soy	127.67	108.46	98.68",
    "Moi's Bridge	127.73	108.53	98.74",
    "Turbo	127.62	108.42	98.64",
    "Kibish	135.73	116.52	106.74",
    "Nakalale	134.56	115.34	105.56",
    "Loima	130.97	111.77	101.98",
    "Lokiriama	132.54	113.33	103.55",
    "Kainuk	129.74	110.54	100.75",
    "Kacheliba	129.07	109.87	100.08",
    "Kiwawa	129.68	110.47	100.69",
    "Ortum	129.27	110.06	100.28",
    "Kachibora	128.06	108.85	99.07",
    "Kwanza	128.77	109.57	99.78",
    "Kaplamai	128.09	108.89	99.10",
    "Eldama Ravine	128.50	109.30	99.51",
    "Tenges	128.64	109.44	99.65",
    "Barwessa	128.76	109.56	99.77",
    "Kipsaraman	129.66	110.46	100.68",
    "Loruk	129.54	110.33	100.55",
    "Kabartonjo	128.50	109.30	99.51",
    "Tindiret	128.56	109.36	99.58",
    "O'lessos	127.73	108.53	98.74",
    "Kobujoi	128.14	108.94	99.14",
    "Serem	128.22	109.01	99.23",
    "Kabiyet	127.67	108.46	98.68",
    "Cheptulu	128.10	108.90	99.11",
    "Songor	128.64	109.44	99.65",
    "Kapcherop	128.28	109.08	99.29",
    "Sambalat	128.96	109.76	99.98",
    "Arror	128.62	109.41	99.63",
    "Tot	128.82	109.62	99.84",
    "Kaptarakwa	127.86	108.66	98.87",
    "Kisumu	127.67	108.46	98.68",
    "Sondu	127.76	108.56	98.78",
    "Oyugis	128.25	109.05	99.26",
    "Kakamega	127.71	108.51	98.72",
    "Mumias	127.99	108.79	99.00",
    "Bondo	127.87	108.67	98.89",
    "Siaya	128.00	108.80	99.01",
    "Kericho	128.17	108.97	99.19",
    "Nyamira	128.24	109.04	99.25",
    "Kisii	128.54	109.34	99.55",
    "Sotik	128.38	109.18	99.38",
    "Keroka	128.56	109.36	99.57",
    "Busia	128.53	109.33	99.54",
    "Homabay	128.48	109.27	99.49",
    "Migori	129.33	110.13	100.34",
    "Isebania	129.62	110.42	100.63",
    "Bomet	128.78	109.58	99.79",
    "Muhoroni	127.89	108.69	98.91",
    "Mbita	128.47	109.26	99.48",
    "Mbale	127.67	108.46	98.68",
    "Etago	129.11	109.91	100.13",
    "Magenche	129.22	110.02	100.23",
    "Kilgoris	129.05	109.85	100.06"
  ];
  Widget getTextWidgets(List<String> strings) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    List<Widget> list = [];
    for (var i = 0; i < strings.length; i++) {
      var newStr = strings[i].split(' ');
      // var town = newStr[0];
      // var super = newStr[1];
      // var diesel = newStr[2];
      // var kerosene = newStr
      list.add(Material(
          elevation: 1.0,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
              width: width * 0.8,
              height: height * 0.08,
              color: Color(0xff322C40),
              margin: EdgeInsets.only(bottom: height*0.01, top: height*0.01),
              // padding: EdgeInsets.only(bottom: height * 0.05),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: new Text(strings[i],style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 20))),
                ],
              ))));
    }
    return new ListView(children: list);
  }

  _getData() async {
    final webScraper = WebScraper('https://www.epra.go.ke');
    if (await webScraper.loadWebPage('/services/petroleum/petroleum-prices')) {
      // List<Map<String, dynamic>> newresults = webScraper.getElement(address, attribs)
      ////*[@id="table_1"]
      List<Map<String, dynamic>> results =
          webScraper.getElement('div.wpdt-c', ['title']);
      List<Map<String, dynamic>> town =
          webScraper.getElement('tr.odd', ['role'], extraAddress: 'tr.even');
      // print(results[1]['title']);
      //print('/n');
      // writeToFile(results.length);

      setState(() {
        loaded = true;
        marketPrice = results[0]['title'];
        //marketPrice = town[0]['town'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
     var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return loaded
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(0xff322C40),
              // leading: IconButton(
              //   icon: Icon(
              //     Icons.arrow_back,
              //   ),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              // ),
              title: Text('Market Prices'),
              // actions: [
              //   IconButton(
              //       icon: Icon(Icons.search_outlined, color: Colors.white,),
              //       onPressed: null
              //   ),
              // ],
            ),
            body: Container(
              child: ListTile(
                title: Material(
          elevation: 1.0,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
              width: width * 0.8,
              height: height * 0.04,
              //color: Color(0xff322C40),
              // margin: EdgeInsets.only(bottom: height*0.02, top: height*0.02),
              // padding: EdgeInsets.only(bottom: height * 0.05),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: new Text("Town || Super || Diesel || Kerosene",style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 20))),
                ],
              ))),
                subtitle: (loaded)
                    ? getTextWidgets(list)
                    : SpinKitRotatingCircle(
                        color: Color(0xff322C40),
                        size: 40.0,
                      ),
              ),
            ),
          )
        : LoadingScreen();
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

Future<File> writeToFile(counter) async {
  final file = await _localFile;

  // Write the file
  return file.writeAsString('$counter');
}

Future<int> readCounter() async {
  try {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();
    print(contents);
    return int.parse(contents);
  } catch (e) {
    // If encountering an error, return 0
    return 0;
  }
}
