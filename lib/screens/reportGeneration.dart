import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ola_energy/models/petrol.dart';
import 'package:ola_energy/widgets/multi_form_reports.dart';
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

    if (widget.update) {
      controllerFuel.text = widget.petrol.fuel;
      controllerLpg.text = widget.petrol.lpg;
      controllerLube.text = widget.petrol.lubes;
      pickedDate = widget.petrol.date.toDate();
    } else {
      pickedDate = DateTime.now();
    }
  }
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
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
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
                      icon: Icon(Icons.delete),
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
                        'Date Today : ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}'),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: TextFormField(
                  controller: controllerLube,
                  //initialValue: widget.petrol.lubes,
                  decoration: InputDecoration(
                    labelText: 'LUBE',
                    hintText: 'Enter lube amount sold',
                    icon: Icon(Icons.local_gas_station),
                    isDense: true,
                  ),
                  onSaved: (val) => val.length > 0 ? null : 'Enter valid data',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: TextFormField(
                  controller: controllerLpg,
                  //initialValue: widget.petrol.lpg,
                  onSaved: (val) => val.length > 0 ? null : 'Enter valid data',
                  decoration: InputDecoration(
                    labelText: 'LPG',
                    hintText: 'Enter LPG amount sold',
                    icon: Icon(Icons.local_gas_station),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: TextFormField(
                  controller: controllerFuel,
                  // initialValue: widget.petrol.fuel,
                  onSaved: (val) => val.length > 0 ? null : 'Enter valid data',
                  decoration: InputDecoration(
                    labelText: 'FUEL',
                    hintText: 'Enter fuel amount sold',
                    icon: Icon(Icons.local_gas_station),
                    isDense: true,
                  ),
                ),
              ),
              FlatButton(
                child: Text(
                  widget.update ? 'Update' : 'Save',
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
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
                  }
                  else {
                    //create collection and save data
                    String randomId=randomAlphaNumeric(32);
                    Map<String, dynamic> data = {
                      'fuelId':randomId,
                      'userId': uid,
                      'lpg': int.parse(controllerLpg.text),
                      'lube': int.parse(controllerLube.text),
                      'fuel': int.parse(controllerFuel.text),
                      'date': pickedDate,
                    };
                    FirebaseFirestore.instance.collection('fuels').doc(randomId).set(data);
                     Navigator.pop(context);
                  }
                },
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
