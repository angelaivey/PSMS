import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ola_energy/models/EmptyState.dart';
import 'package:ola_energy/models/petrol.dart';
import 'package:ola_energy/screens/reportGeneration.dart';
import 'package:ola_energy/widgets/progress.dart';

class MultiForm extends StatefulWidget {
  @override
  _MultiFormState createState() => _MultiFormState();
}

class _MultiFormState extends State<MultiForm> {
  List<ReportGenerator> petrol = [];

//  final form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff07239d),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Daily Sales Forms'),
        actions: <Widget>[
          FlatButton(
            child: Text('Save All'),
            textColor: Colors.white,
            onPressed: () {},
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("fuels")
            .orderBy("date", descending: true)
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
                child: Material(
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
                          backgroundColor: Color(0xff07239d),
                          actions: [
                            IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // onDelete();
                                  //deleteData();
                                }),
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
                                  'Date Today : ${DateFormat().add_yMMMEd().format(asyncSnapshot.data.docs[index].data()["date"].toDate())}'),
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
                                Text(asyncSnapshot.data.docs[index]
                                    .data()["lube"]
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
                                Text(asyncSnapshot.data.docs[index]
                                    .data()["lpg"]
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
                                Text(asyncSnapshot.data.docs[index]
                                    .data()["fuel"]
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
                                  docsId: asyncSnapshot.data.docs[index].id,
                                  petrol: Petrol(
                                    lubes: asyncSnapshot.data.docs[index]
                                        .data()["lube"]
                                        .toString(),
                                    fuel: asyncSnapshot.data.docs[index]
                                        .data()["fuel"]
                                        .toString(),
                                    date: asyncSnapshot.data.docs[index]
                                        .data()["date"],
                                    lpg: asyncSnapshot.data.docs[index]
                                        .data()["lpg"]
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
        backgroundColor: Color(0xff07239d),
        child: Icon(Icons.add),
        onPressed: () {
          _dialog(update:false);
        },
        foregroundColor: Colors.white,
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
              // onDelete: () => onDelete(_petrol),
            ));
  }

  ///on form user deleted
// void onDelete(Petrol _petrol) {
//   setState(() {
//     var find = petrol.firstWhere(
//           (it) => it.petrol == _petrol,
//       orElse: () => null,
//     );
//     if (find != null) petrol.removeAt(petrol.indexOf(find));
//   });
// }

  ///on add form
// void onAddForm() {
//   setState(() {
//     var _petrol = Petrol();
//     petrol.add(
//        ));
//   });
//}

  ///on save forms
// void onSave() {
//   if (petrol.length > 0) {
//     var allValid = true;
//     petrol.forEach((form) => allValid = allValid && form.isValid());
//     if (allValid) {
//       var data = petrol.map((it) => it.petrol).toList();
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           fullscreenDialog: true,
//           builder: (_) => Scaffold(
//             appBar: AppBar(
//               title: Text('List of Reports'),
//             ),
//             body: ListView.builder(
//               itemCount: data.length,
//               itemBuilder: (_, i) => ListTile(
//                 leading: Icon(Icons.local_gas_station),
//                 title: Text(data[i].lpg),
//                 subtitle: Text(data[i].lubes),
//                 trailing: Text(data[i].fuel),
//                 // title: Text(data[i].fullName),
//                 // subtitle: Text(data[i].email),
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//   }
// }
}
