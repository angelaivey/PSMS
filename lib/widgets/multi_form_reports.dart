import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ola_energy/models/EmptyState.dart';
import 'package:ola_energy/models/petrol.dart';
import 'package:ola_energy/screens/registration.dart';
import 'package:ola_energy/screens/reportGeneration.dart';
import 'package:ola_energy/widgets/progress.dart';

class MultiForm extends StatefulWidget {

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
      uid= user.uid;
    });
    return  user.uid;

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   _userId();
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
            .collection("fuels")
            .orderBy("date", descending: true)
            .where('userId', isEqualTo: uid)
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
                child:fuelWidget(
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff322C40),
        child: Icon(Icons.add),
        onPressed: () {
          _dialog(update:false);
        },
        foregroundColor: Colors.white,
      ),
    );
  }
   fuelWidget(date, fuel, fuelId, lpg, lube, userId){
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
                  onPressed: (){
                    deleteForm(fuelId);
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
              title: Text('Daily Form'),
            ),
            Padding(
              padding:
              EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // IconButton(icon: Icon(Icons.keyboard_arrow_down),
                  //   onPressed: _pickedDate,
                  // ),
                  Text(
                      'Date Today : '+DateFormat().add_yMMMEd().format(date.toDate()).toString()),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  children: [
                    Text('Lube: '),
                    SizedBox(width: 10.0,),
                    Text(lube
                        .toString()),
                  ],
                )
            ),
            Padding(
                padding:
                EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Row(
                  children: [
                    Text('LPG: '),
                    SizedBox(width: 10.0,),
                    Text(lpg
                        .toString()),
                  ],
                )
            ),
            Padding(
                padding:
                EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Row(
                  children: [
                    Text('Fuel: '),
                    SizedBox(width: 10.0,),
                    Text(fuel
                        .toString()),
                  ],
                )
            ),
            Center(
              child: FlatButton(
                child: Text(
                  'Update',
                  style: TextStyle(
                      color: Colors.black, fontSize: 20.0),
                ),
                onPressed: () {
                  _dialog(
                      update: true,
                      docsId: fuelId,
                      petrol: Petrol(
                        lubes: lube
                            .toString(),
                        fuel: fuel
                            .toString(),
                        date: date,
                        lpg: lpg
                            .toString(),
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
              ),
            ),
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
    return fuels
        .doc(fuelId.toString())
        .delete()
        .then((value) {
      Fluttertoast.showToast(
          msg: 'Form Deleted',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xff322C40),
          textColor: Colors.white,
          fontSize: 16.0);
    })
        .catchError((error) {
          Fluttertoast.showToast(
              msg: "Error: $error",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
      print(error.toString());
    });
  }
  bool inExistence=true;
  _checkFuelExistence(fuelId) async{
    //instead of refreshing page when post is deleted, it MAY check if post still exists in firebase
    //and if not the will not be displayed
    await FirebaseFirestore.instance.collection('fuels')
        .where('fuelId', isEqualTo:fuelId)
        .get()
        .then((value){
      value.docs.forEach((result) {
        setState(() {
          inExistence=true;
        });

      });
    }).catchError((err){
      print(err.message);
      setState(() {
        inExistence=false;
      });
    });
  }
}
