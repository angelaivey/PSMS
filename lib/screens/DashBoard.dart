import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ola_energy/screens/employees.dart';
import 'package:ola_energy/screens/sales.dart';
import '../models/EmptyState.dart';
import '../screens/EditProfile.dart';
import '../screens/registration.dart';
import '../screens/reportGeneration.dart';
import '../screens/settings.dart';
import '../screens/station.dart';
import '../widgets/bezierContainer.dart';
import '../widgets/multi_form_reports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AnalyticsPage.dart';
import 'HomePage.dart';
import 'MarketPrices.dart';
import 'login.dart';

class DashBoard extends StatefulWidget {
  // static Route<Object> route;
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String employeeId;
  String userEmail, accType;
  String userLocation;
  String stationId = "";
  @override
  void initState() {
    super.initState();
    _fetchStoredData();
  }

  Future _fetchStoredData() async {
    final SharedPreferences _sp = await SharedPreferences.getInstance();
    print("Fetched from shared p ${_sp.getString("employeeId")}");
    setState(() {
      employeeId = _sp.getString("employeeId");
      userEmail = _sp.getString("email");
      accType = _sp.getString("accType");
      stationId = _sp.getString("stationId");
      //userLocation = _sp.getString("location");
      //_fetchstationId(_sp.getString("employeeId"));
      print("Fetched from shared p ${_sp.getString("employeeId")}");
    });
  }

  _fetchstationId(employeeId) async {
    //instead of refreshing page when post is deleted, it MAY check if post still exists in firebase
    //and if not the will not be displayed
    await FirebaseFirestore.instance
        .collection('users')
        .where('employeeId', isEqualTo: employeeId)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        setState(() {
          stationId = result.data()['stationId'];
          //accType = result.
        });
      });
    }).catchError((err) {
      print(err.message);
    });
  }

  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; //to get size
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: stationId != ""
          ? Stack(
              children: <Widget>[
                Positioned(
                  top: -MediaQuery.of(context).size.height * .15,
                  right: -MediaQuery.of(context).size.width * .2,
                  bottom: -MediaQuery.of(context).size.height * .12,
                  left: -MediaQuery.of(context).size.width * .3,
                  child: BezierContainer(),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: screenHeight * 0.1,
                          padding: EdgeInsets.all(screenHeight * 0.02),
                          decoration: BoxDecoration(
                              color: Color(0xff322C40),
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfile()));
                                  },
                                  child: GestureDetector(
                                      child: Icon(
                                    Icons.badge_outlined,
                                    size: screenHeight * 0.04,
                                    color: Color(0xfff3f3f4),
                                  ))),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Welcome',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200,
                                      color: Color(0xfff3f3f4),
                                    ),
                                  ),
                                  Text(
                                    '$employeeId' ?? "",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xfff3f3f4),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    await FirebaseAuth.instance
                                        .signOut()
                                        .then((value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()));
                                    });
                                  },
                                  child: Icon(
                                    Icons.logout_outlined,
                                    size: screenHeight * 0.04,
                                    color: Color(0xfff3f3f4),
                                  ))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: GridView.count(
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        // SvgPicture.asset(
                                        //   'assets/images/update.svg',
                                        //   height: 58,
                                        //   color: Color(0xff322C40),
                                        // ),

                                        Icon(
                                          Icons.feed,
                                          size: screenHeight * 0.09,
                                          color: Color(0xff322C40),
                                        ),

                                        SizedBox(height: 10),
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
                                            builder: (context) =>
                                                MarketPrices()));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        // SvgPicture.asset(
                                        //   'assets/images/stocks.svg',
                                        //   height: screenHeight * 0.09,
                                        //   color:Color(0xff322C40)
                                        // ),
                                        Icon(
                                          Icons.sell_outlined,
                                          size: screenHeight * 0.09,
                                          color: Color(0xff322C40),
                                        ),

                                        SizedBox(height: 10),
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
                                            builder: (context) =>
                                                accType == 'Admin #OEAA01A'
                                                    ? ReportManagers()
                                                    : MultiForm()));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        // SvgPicture.asset(
                                        //   'assets/images/report.svg',
                                        //   height: 58,
                                        //     color: Color(0xff322C40)
                                        // ),
                                        Icon(
                                          Icons.summarize_outlined,
                                          size: screenHeight * 0.09,
                                          color: Color(0xff322C40),
                                        ),

                                        SizedBox(height: 10),
                                        accType ==
                                                'Filling Station Attendant #OEEM02C'
                                            ? Text('Generate Reports')
                                            : Text('Reports')
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AnalyticsPage()));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        // SvgPicture.asset(
                                        //   'assets/images/oil-market.svg',
                                        //   height: 58,
                                        //   color: Color(0xff322C40)
                                        // ),
                                        Icon(
                                          Icons.poll,
                                          size: screenHeight * 0.09,
                                          color: Color(0xff322C40),
                                        ),

                                        SizedBox(height: 10),
                                        Text('Analysis')
                                      ],
                                    ),
                                  ),
                                ),
                                accType != 'Filling Station Attendant #OEEM02C'
                                    ? GestureDetector(
                                        onTap: () {
                                         accType ==
                                            'Admin #OEAA01A'
                                            ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                       SupervisorView()))
                                            :Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                       ViewAllEmployees(location: stationId,)));
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          elevation: 4,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.supervisor_account_outlined,
                                                size: screenHeight * 0.09,
                                                color: Color(0xff322C40),
                                              ),
                                              SizedBox(height: 20),
                                              Text('Employees')
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                               accType != 'Filling Station Attendant #OEEM02C'
                                    ? GestureDetector(
                                        onTap: () {
                                        //  accType ==
                                        //     'Admin #OEAA01A'
                                        //     ? 
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                       LocationSales()))
                                            // :Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //       builder: (context) =>
                                            //            ViewAllEmployees(location: stationId,)))
                                            ;
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          elevation: 4,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.receipt_long_outlined,
                                                size: screenHeight * 0.09,
                                                color: Color(0xff322C40),
                                              ),
                                              SizedBox(height: 20),
                                              Text('Sales')
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                              crossAxisCount: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: SpinKitRotatingCircle(
                color: Color(0xff322C40),
                size: 40.0,
              ),
            ),
    );
  }
}
