import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ola_energy/screens/EditProfile.dart';
import 'package:ola_energy/screens/reportGeneration.dart';
import 'package:ola_energy/screens/settings.dart';
import 'package:ola_energy/screens/station.dart';
import 'AnalyticsPage.dart';
import 'HomePage.dart';
import 'MarketPrices.dart';

class DashBoard extends StatefulWidget {
  static Route<Object> route;
  DashBoard({this.uid});

  final String uid;
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;   //to get size

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
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
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 64,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                            },
                            child: CircleAvatar(
                              radius: 32,
                              backgroundImage: AssetImage('assets/images/m1.jpeg'),
                            ),
                          ),
                          SizedBox(width: 16,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('John',
                                style: GoogleFonts.portLligatSans(
                                  textStyle: Theme.of(context).textTheme.display1,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text('Bellevue branch',
                                style: GoogleFonts.portLligatSans(
                                  textStyle: Theme.of(context).textTheme.display1,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ),
                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        primary: false,
                        children: <Widget> [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/images/home.svg',
                                    height: 128,
                                  ),
                                  Text('Home')
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => MarketPrices()));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/images/oil-market.svg',
                                    height: 128,
                                  ),
                                  Text('Market Prices')
                                ],
                              ),
                            ),
                          ),
                          // Card(
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(10)
                          //   ),
                          //   elevation: 4,
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: <Widget>[
                          //       SvgPicture.asset(
                          //         'assets/images/stocks.svg',
                          //         height: 128,
                          //       ),
                          //       Text('Stocks')
                          //     ],
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => StationsList()));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/images/gasoline-pump.svg',
                                    height: 128,
                                  ),
                                  Text('Choose station')
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateReport()));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/images/paper.svg',
                                    height: 128,
                                  ),
                                  Text('Generate Reports')
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AnalyticsPage()));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/images/analytics.svg',
                                    height: 128,
                                  ),
                                  Text('Analysis')
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/images/settings.svg',
                                    height: 128,
                                  ),
                                  Text('Settings')
                                ],
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: (){
                          //     Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs()));
                          //   },
                          //   child: Card(
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10)
                          //     ),
                          //     elevation: 4,
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: <Widget>[
                          //         SvgPicture.asset(
                          //           'assets/images/about.svg',
                          //           height: 128,
                          //         ),
                          //         Text('About Us')
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                        crossAxisCount: 2,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
