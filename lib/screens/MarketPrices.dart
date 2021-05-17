import 'package:flutter/material.dart';
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

  _getData() async {
    webScraper = WebScraper('https://www.epra.go.ke/services/petroleum/petroleum-prices/');
    if(await webScraper.loadWebPage('/')){
      List<Map<String, dynamic>> results =
      webScraper.getElement('div.wpdt-c',        ['title']);
      List<Map<String, dynamic>> town= webScraper.getElement('tbody',['title']);
      print(town);
      //print('/n');
      setState(() {
        loaded = true;
        marketPrice = town[0]['title'];
        //marketPrice = town[0]['town'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff07239d),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: Text('Market Prices'),
      ),
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.all(Radius.circular(1)),
        //   boxShadow: <BoxShadow>[
        //     BoxShadow(
        //         color: Colors.grey.shade200,
        //         offset: Offset(2, 4),
        //         blurRadius: 5, //
        //         spreadRadius: 2)
        //   ],
        //   gradient: LinearGradient(
        //       begin: Alignment.topRight,
        //       end: Alignment.topLeft,
        //       colors: [Color(0xffe46b10), Color(0xff07239d)]
        //   ),
        // ),
         child:
            ListTile(
              title: Text("Retail Petroleum Prices", style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),),
              subtitle: (loaded)? ListView(
                children: [
                  Text(marketPrice,
                  style: TextStyle(
                    color: Colors.black,
                    ),
                  ),
                ]
              )
                  : CircularProgressIndicator(),
            ),
        ),
    );
  }
}

