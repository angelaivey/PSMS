import 'package:flutter/material.dart';

class ListPrices {
  final name;
  final price;

  ListPrices(this.name, this.price);
}

// ignore: must_be_immutable
class MarketPrices extends StatelessWidget {
  List listPrices = [
    ListPrices(
        'Diesel',
        'KSH 103.3'
    ),
    ListPrices(
        'Unleaded premium',
        'KSH 110.3'
    ),
    ListPrices(
        'Kerosene',
        'KSH 64.3'
    ),
    ListPrices(
        'Engine oil',
        'KSH 560.3'
    ),
    ListPrices(
        'Lubricants',
        'KSH 400.3'
    ),
    ListPrices(
        'Gas Cylinders',
        'KSH 2000'
    ),
    ListPrices(
        'Gas refill',
        'KSH 1300'
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Color(0xff07239d),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Market Prices'),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(1)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5, //
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.topLeft,
                colors: [Color(0xffe46b10), Color(0xff07239d)]
            ),
          ),
        child: ListView(
          children: <Widget>[
            Column(
                children: listPrices
                    .map(
                      (e) => Container(
                    margin:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        e.name,
                        style: TextStyle(fontSize: 25),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(e.price.toString()),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                )
                    .toList())
          ],
        ),
      ),
    );
  }
}
