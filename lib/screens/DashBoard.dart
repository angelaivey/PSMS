import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ola_energy/models/EmptyState.dart';
import 'package:ola_energy/screens/EditProfile.dart';
import 'package:ola_energy/screens/registration.dart';
import 'package:ola_energy/screens/reportGeneration.dart';
import 'package:ola_energy/screens/settings.dart';
import 'package:ola_energy/screens/station.dart';
import 'package:ola_energy/screens/upload.dart';
import 'package:ola_energy/widgets/bezierContainer.dart';
import 'package:ola_energy/widgets/multi_form_reports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AnalyticsPage.dart';
import 'HomePage.dart';
import 'MarketPrices.dart';

class DashBoard extends StatefulWidget {
  static Route<Object> route;


  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String userName;
  String userEmail;
  String userLocation;
  String photoUrl;

  Future storedData() async {
    final SharedPreferences _sp = await SharedPreferences.getInstance();
    print("Fetched from shared p ${_sp.getString("username")}");
    setState(() {
      userName =  _sp.getString("username");
      userEmail = _sp.getString("email");
      userLocation = _sp.getString("location");
      photoUrl = _sp.getString("photoUrl");
      print("Fetched from shared p ${_sp.getString("username")}");
    });
  }

  @override
  void initState() {
    super.initState();
    storedData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; //to get size

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: -MediaQuery.of(context).size.height * .15,
            right: -MediaQuery.of(context).size.width * .2,
            bottom: -MediaQuery.of(context).size.height * .12,
            left: -MediaQuery.of(context).size.width * .3,
            child: BezierContainer(),
          ),
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 20),
            // height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                // BoxShadow(
                //     color: Colors.grey.shade200,
                //     offset: Offset(2, 4),
                //     blurRadius: 5, //
                //     spreadRadius: 2)
              ],
              // gradient: LinearGradient(
              //     begin: Alignment.topRight,
              //     end: Alignment.topLeft,
              //     colors: [Color(0xffe46b10), Color(0xff07239d)]),
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile()));
                          },
                          child: CircleAvatar(
                            radius: 32,
                            backgroundImage:NetworkImage(photoUrl??""),
                             //   AssetImage('assets/images/m1.jpeg'),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Welcome $userName' ?? "",
                              style: GoogleFonts.portLligatSans(
                                textStyle: Theme.of(context).textTheme.display1,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            // Text(
                            //   'Email: $userEmail' ?? "",
                            //   style: GoogleFonts.portLligatSans(
                            //     textStyle: Theme.of(context).textTheme.display1,
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.w300,
                            //     color: Colors.black,
                            //   ),
                            // ),
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
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Upload()));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/images/update.svg',
                                  height: 128,
                                ),
                                Text('Updates')
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MarketPrices()));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/images/stocks.svg',
                                  height: 128,
                                ),
                                Text('Market Prices')
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MultiForm()));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/images/report.svg',
                                  height: 128,
                                ),
                                Text('Generate Reports')
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AnalyticsPage()));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/images/oil-market.svg',
                                  height: 128,
                                ),
                                Text('Analysis')
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/images/about.svg',
                                  height: 128,
                                ),
                                Text('About Us')
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile()));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
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
