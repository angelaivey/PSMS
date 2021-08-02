import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/EmptyState.dart';
import '../models/petrol.dart';
import '../screens/registration.dart';
import '../screens/reportGeneration.dart';
import '../widgets/progress.dart';

class MultiForm extends StatefulWidget {
  final String locationIdentification;
  MultiForm({Key key, this.locationIdentification}) : super(key: key);
  @override
  _MultiFormState createState() => _MultiFormState();
}

class _MultiFormState extends State<MultiForm> {
  List<ReportGenerator> petrol = [];
  String uid;
  Future<String> _userId() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final User user = auth.currentUser;

    setState(() {
      uid = user.uid;
    });
    return user.uid;
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _fetchStoredData();
    _userId();
  }

  String employeeId, userEmail, stationId, accType;
  Future _fetchStoredData() async {
    final SharedPreferences _sp = await SharedPreferences.getInstance();
    // print("Fetched from shared p ${_sp.getString("employeeId")}");
    setState(() {
      employeeId = _sp.getString("employeeId");
      userEmail = _sp.getString("email");
      stationId = widget.locationIdentification ?? _sp.getString("stationId");
      accType = _sp.getString("accType");
    });
    print('----------------------------------------------------------');
    print(accType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff322C40),
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     }),
        title: Text('Daily Sales Forms'),
      ),
      body: accType != "Filling Station Attendant #OEEM02C"
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("fuels")
                  .orderBy("date", descending: true)
                  // not limited to the user ID
                  // .where('userId', isEqualTo: uid)
                  .where("stationId", isEqualTo: stationId)
                  .snapshots(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.hasError) {
                  return Center(child: Text("Error!"));
                } else if (asyncSnapshot.hasData) {
                  print("DATA CHUNK LENGTH ${asyncSnapshot.data.docs.length}");
                  return ListView.builder(
                    itemCount: asyncSnapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: EdgeInsets.all(8.0),
                      child: fuelWidgetManager(
                        asyncSnapshot.data.docs[index].data()["date"],
                        asyncSnapshot.data.docs[index].data()["fuel"],
                        asyncSnapshot.data.docs[index].data()["fuelId"],
                        asyncSnapshot.data.docs[index].data()["lpg"],
                        asyncSnapshot.data.docs[index].data()["lube"],
                        asyncSnapshot.data.docs[index].data()["userId"],
                        asyncSnapshot.data.docs[index].data()["stationId"],
                        asyncSnapshot.data.docs[index].data()["employeeId"],
                      ),
                    ),
                  );
                } else if (asyncSnapshot.hasData &&
                    asyncSnapshot.data.docs.length == 0) {
                  return EmptyState();
                } else if (!asyncSnapshot.hasData) {
                  return circularProgress();
                }
                return null;
              },
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("fuels")
                  .orderBy("date", descending: true)
                  .where('userId', isEqualTo: uid)
                  .where("stationId", isEqualTo: stationId)
                  .snapshots(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.hasError) {
                  return Center(child: Text("Error!"));
                } else if (asyncSnapshot.hasData) {
                  print("DATA CHUNK LENGTH ${asyncSnapshot.data.docs.length}");
                  return ListView.builder(
                    itemCount: asyncSnapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: EdgeInsets.all(8.0),
                      child: fuelWidget(
                        asyncSnapshot.data.docs[index].data()["date"],
                        asyncSnapshot.data.docs[index].data()["fuel"],
                        asyncSnapshot.data.docs[index].data()["fuelId"],
                        asyncSnapshot.data.docs[index].data()["lpg"],
                        asyncSnapshot.data.docs[index].data()["lube"],
                        asyncSnapshot.data.docs[index].data()["userId"],
                      ),
                    ),
                  );
                } else if (asyncSnapshot.hasData &&
                    asyncSnapshot.data.docs.length == 0) {
                  return EmptyState();
                } else if (!asyncSnapshot.hasData) {
                  return circularProgress();
                }
                return null;
              },
            ),
      floatingActionButton: accType != "Filling Station Attendant #OEEM02C"
          ? SizedBox(
              height: 0,
            )
          : FloatingActionButton(
              backgroundColor: Color(0xff322C40),
              child: Icon(Icons.add),
              onPressed: () {
                _dialog(update: false);
              },
              foregroundColor: Colors.white,
            ),
    );
  }

  fuelWidgetManager(
      date, fuel, fuelId, lpg, lube, userId, stationId, employeeId) {
    return Material(
      elevation: 1.0,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(8.0),
      child: Form(
        //  key: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              leading: Icon(Icons.local_gas_station),
              elevation: 0,
              backgroundColor: Color(0xff322C40),
              actions: [
                IconButton(
                  onPressed: () {
                    _dialog(
                        update: true,
                        docsId: fuelId,
                        petrol: Petrol(
                          lubes: lube.toString(),
                          fuel: fuel.toString(),
                          date: date,
                          lpg: lpg.toString(),
                        ));
                    //create collection and save data
                    Map<String, dynamic> data = {
                      // 'lpg' : int.parse(controllerLpg.text),
                      // 'lube' : int.parse(controllerLube.text),
                      // 'fuel' : int.parse(controllerFuel.text),
                      // 'date' : pickedDate,
                    };
                    // FirebaseFirestore.instance.collection('fuels').add(data);
                    // Navigator.pop(context);
                  },
                  icon: Icon(Icons.update),
                ),
                IconButton(
                  onPressed: () {
                    deleteForm(fuelId);
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
              title: Text(employeeId.toString()),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // IconButton(icon: Icon(Icons.keyboard_arrow_down),
                  //   onPressed: _pickedDate,
                  // ),
                  Text('Date Posted : ' +
                      DateFormat()
                          .add_yMMMEd()
                          .format(date.toDate())
                          .toString()),
                  Text('Time Posted : ' +
                      DateFormat().add_Hm().format(date.toDate()).toString()),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Posted At: '),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(stationId.toString()),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Posted By:'),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(employeeId.toString()),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Lube (lts): '),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(lube.toString()),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('LPG (lts): '),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(lpg.toString()),
                  ],
                )),
            Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Fuel (lts): '),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(fuel.toString()),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  fuelWidget(date, fuel, fuelId, lpg, lube, userId) {
    return Material(
      elevation: 1.0,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(8.0),
      child: Form(
        //  key: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              leading: Icon(Icons.local_gas_station),
              elevation: 0,
              backgroundColor: Color(0xff322C40),
              // actions: [
              // IconButton(
              //   onPressed: () {
              //     _dialog(
              //         update: true,
              //         docsId: fuelId,
              //         petrol: Petrol(
              //           lubes: lube.toString(),
              //           fuel: fuel.toString(),
              //           date: date,
              //           lpg: lpg.toString(),
              //         ));
              //     //create collection and save data
              //     Map<String, dynamic> data = {
              //       // 'lpg' : int.parse(controllerLpg.text),
              //       // 'lube' : int.parse(controllerLube.text),
              //       // 'fuel' : int.parse(controllerFuel.text),
              //       // 'date' : pickedDate,
              //     };
              //     // FirebaseFirestore.instance.collection('fuels').add(data);
              //     // Navigator.pop(context);
              //   },
              //   icon: Icon(Icons.update),
              // ),
              //   IconButton(
              //     onPressed: () {
              //       deleteForm(fuelId);
              //     },
              //     icon: Icon(Icons.delete),
              //   ),
              // ],
              title: Text(employeeId.toString()),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // IconButton(icon: Icon(Icons.keyboard_arrow_down),
                  //   onPressed: _pickedDate,
                  // ),
                  Text('Date Posted : ' +
                      DateFormat()
                          .add_yMMMEd()
                          .format(date.toDate())
                          .toString()),
                  Text('Time Posted : ' +
                      DateFormat().add_Hm().format(date.toDate()).toString()),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Lube (lts): '),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(lube.toString()),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('LPG (lts): '),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(lpg.toString()),
                  ],
                )),
            Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Fuel (lts): '),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(fuel.toString()),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _dialog({bool update, docsId, petrol}) {
    return showDialog(
        context: context,
        builder: (context) => ReportGenerator(
              petrol: petrol,
              docsId: docsId,
              update: update,
            ));
  }

  CollectionReference fuels = FirebaseFirestore.instance.collection('fuels');

  Future<void> deleteForm(fuelId) {
    return fuels.doc(fuelId.toString()).delete().then((value) {
      Fluttertoast.showToast(
          msg: 'Form Deleted',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xff322C40),
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Error: $error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(error.toString());
    });
  }

  bool inExistence = true;
  _checkFuelExistence(fuelId) async {
    //instead of refreshing page when post is deleted, it MAY check if post still exists in firebase
    //and if not the will not be displayed
    await FirebaseFirestore.instance
        .collection('fuels')
        .where('fuelId', isEqualTo: fuelId)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        setState(() {
          inExistence = true;
        });
      });
    }).catchError((err) {
      print(err.message);
      setState(() {
        inExistence = false;
      });
    });
  }
}
// the admin's list should have a list view of managers and locations

class ReportManagers extends StatefulWidget {
  const ReportManagers({Key key}) : super(key: key);

  @override
  _ReportManagersState createState() => _ReportManagersState();
}

class _ReportManagersState extends State<ReportManagers> {

  void fetchLocationId(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff322C40),
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     }),
        title: Text('Daily Sales Forms'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
           // .orderBy("date", descending: true)
            // not limited to the user ID
            // .where('userId', isEqualTo: uid)
            .where("accountType", isEqualTo: "Manager #OEEM01A"  )
            // .where("stationId", isEqualTo: stationId)
            .snapshots(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return Center(child: Text("Error!"));
          } else if (asyncSnapshot.hasData) {
            print("DATA CHUNK LENGTH ${asyncSnapshot.data.docs.length}");
            return ListView.builder(
              itemCount: asyncSnapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MultiForm(
                                    locationIdentification: asyncSnapshot
                                        .data.docs[index]
                                        .data()["stationId"],
                                  )));
                    },
                    child: reportCard(
                        context,
                        asyncSnapshot.data.docs[index].data()["employeeId"],
                        asyncSnapshot.data.docs[index].data()["stationId"]),
                  )
                  // fuelWidgetManager(
                  //   asyncSnapshot.data.docs[index].data()["date"],
                  //   asyncSnapshot.data.docs[index].data()["fuel"],
                  //   asyncSnapshot.data.docs[index].data()["fuelId"],
                  //   asyncSnapshot.data.docs[index].data()["lpg"],
                  //   asyncSnapshot.data.docs[index].data()["lube"],
                  //   asyncSnapshot.data.docs[index].data()["userId"],
                  //   asyncSnapshot.data.docs[index].data()["stationId"],
                  //   asyncSnapshot.data.docs[index].data()["employeeId"],
                  // ),
                  ),
            );
          } else if (asyncSnapshot.hasData &&
              asyncSnapshot.data.docs.length == 0) {
            return EmptyState();
          } else if (!asyncSnapshot.hasData) {
            return circularProgress();
          }
          return null;
        },
      ),
    );
  }

  Widget reportCard(context, managerId, locationName) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Material(
     // color:  Color(0xff322C40),
      elevation: 1.0,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        width: width * 0.8,
        height: height * 0.2,
      
        padding: EdgeInsets.only(bottom: height*0.05),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Container(
                  height: height*0.1,
                  width: width * 1,
                 // color: Colors.red,
                   decoration: BoxDecoration(color: Color(0xff322C40)),
                  child: Center(
                    child: Text(locationName,
               style: TextStyle(color: Colors.white, fontSize: 20),
              ),
                  ),
                ),
              SizedBox(height:10),
              Text("Manager: "+managerId ?? "not registered",
               style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}
