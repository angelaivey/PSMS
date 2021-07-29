import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/petrol.dart';
import '../widgets/multi_form_reports.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnDelete();

class ReportGenerator extends StatefulWidget {
  final update;
  final String docsId;
  final Petrol petrol;
  final state = _ReportGeneratorState();
  final OnDelete onDelete;
  DateTime date;
  final db = FirebaseFirestore.instance.collection('fuels');

  ReportGenerator(
      {Key key,
      this.onDelete,
      this.petrol,
      this.docsId,
      this.date,
      this.update});

  @override
  _ReportGeneratorState createState() => _ReportGeneratorState();

  bool isValid() => state.validate();
}

class _ReportGeneratorState extends State<ReportGenerator> {
  String fuelId;

  TextEditingController controllerLpg = new TextEditingController();
  TextEditingController controllerLube = new TextEditingController();
  TextEditingController controllerFuel = new TextEditingController();

  final form = GlobalKey<FormState>();
  DateTime pickedDate;

  String id;

  @override
  void initState() {
    super.initState();
    _userId();
    _fetchStoredData();
    if (widget.update) {
      controllerFuel.text = widget.petrol.fuel;
      controllerLpg.text = widget.petrol.lpg;
      controllerLube.text = widget.petrol.lubes;
      pickedDate = widget.petrol.date.toDate();
    } else {
      pickedDate = DateTime.now();
    }
  }

  String uid, employeeId, userEmail, locationString, stationId;
  Future<String> _userId() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;

    setState(() {
      uid = user.uid;
    });
    return user.uid;
  }

  Future _fetchStoredData() async {
    final SharedPreferences _sp = await SharedPreferences.getInstance();
    // print("Fetched from shared p ${_sp.getString("employeeId")}");
    setState(() {
      employeeId = _sp.getString("employeeId");
      userEmail = _sp.getString("email");
      stationId = _sp.getString("stationId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 30,
      padding: EdgeInsets.fromLTRB(
          10,
          MediaQuery.of(context).size.height * 0.22,
          10,
          MediaQuery.of(context).size.height * 0.22),
      child: Material(
        elevation: 1.0,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8.0),
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppBar(
                leading: Icon(Icons.local_gas_station),
                elevation: 0,
                backgroundColor: Color(0xff322C40),
                actions: [
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        onDelete();
                        Navigator.pop(context);
                      }),
                ],
                title: Text('Daily Form'),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_down),
                      onPressed: _pickedDate,
                    ),
                    Text(
                        'Date  : ${pickedDate.year}/ ${pickedDate.month}/ ${pickedDate.day}'),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: controllerLube,
                  //initialValue: widget.petrol.lubes,
                  decoration: InputDecoration(
                    labelText: 'LUBE',
                    hintText: 'eg. 80',
                    icon: Icon(Icons.local_gas_station),
                    isDense: true,
                  ),
                  onSaved: (val) => val.length > 0 ? null : 'Enter valid data',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: controllerLpg,
                  //initialValue: widget.petrol.lpg,
                  onSaved: (val) => val.length > 0 ? null : 'Enter valid data',
                  decoration: InputDecoration(
                    labelText: 'LPG',
                    hintText: 'eg. 150',
                    icon: Icon(Icons.local_gas_station),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: TextFormField(
                  controller: controllerFuel,
                  keyboardType: TextInputType.number,
                  // initialValue: widget.petrol.fuel,
                  onSaved: (val) => val.length > 0 ? null : 'Enter valid data',
                  decoration: InputDecoration(
                    labelText: 'FUEL',
                    hintText: 'eg. 1,000',
                    icon: Icon(Icons.local_gas_station),
                    isDense: true,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                height: MediaQuery.of(context).size.height * 0.065,
                width: MediaQuery.of(context).size.width * 0.88,
                color: Color(0xff322C40),
                child: TextButton(
                  child: Center(
                    child: Text(
                      widget.update ? 'Update' : 'Save',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  onPressed: () {
                    if (widget.update) {
                      Map<String, dynamic> data = {
                        // 'fuelId': widget.docsId,
                        'lpg': int.parse(controllerLpg.text),
                        'lube': int.parse(controllerLube.text),
                        'fuel': int.parse(controllerFuel.text),
                        'date': pickedDate,
                      };
                      FirebaseFirestore.instance
                          .collection('fuels')
                          .doc(widget.docsId)
                          .update(data);
                      Navigator.pop(context);
                    } else {
                      //create collection and save data
                      String randomId = randomAlphaNumeric(32);
                      Map<String, dynamic> data = {
                        'fuelId': randomId,
                        'userId': uid,
                        'employeeId': employeeId,
                        'stationId': stationId,
                                                'lpg': int.parse(controllerLpg.text),
                        'lube': int.parse(controllerLube.text),
                        'fuel': int.parse(controllerFuel.text),
                        'date': pickedDate,
                      };
                      FirebaseFirestore.instance
                          .collection('fuels')
                          .doc(randomId)
                          .set(data);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _pickedDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(DateTime.now().year - 8),
      lastDate: DateTime(DateTime.now().year + 8),
    );
    if (date != null) {
      setState(() {
        //controllerDate = _pickedDate();
        pickedDate = date;
      });
    }
  }

  bool validate() {
    var valid = form.currentState.validate();
    if (valid) form.currentState.save();
    return valid;
  }

  void onDelete() async {
    await FirebaseFirestore.instance.collection('fuels').doc(id).delete();
  }
}
