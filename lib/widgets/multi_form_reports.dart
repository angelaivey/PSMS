import 'package:flutter/material.dart';
import 'package:ola_energy/models/EmptyState.dart';
import 'package:ola_energy/models/petrol.dart';
import 'package:ola_energy/screens/reportGeneration.dart';

class MultiForm extends StatefulWidget {
  @override
  _MultiFormState createState() => _MultiFormState();
}

class _MultiFormState extends State<MultiForm> {
  List<ReportGenerator> petrol = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff07239d),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        title: Text('Daily Sales Forms'),
        actions: <Widget>[
          FlatButton(
            child: Text('Save All'),
            textColor: Colors.white,
            onPressed: (){},
          )
        ],
      ),
      body: Container(
        child: petrol.length <= 0
            ? Center(
          child: EmptyState(),
        )
            : ListView.builder(
          addAutomaticKeepAlives: true,
          itemCount: petrol.length,
          itemBuilder: (_, i) => petrol[i],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff07239d),
        child: Icon(Icons.add),
        onPressed: onAddForm,
        foregroundColor: Colors.white,
      ),
    );
  }

  ///on form user deleted
  void onDelete(Petrol _petrol) {
    setState(() {
      var find = petrol.firstWhere(
            (it) => it.petrol == _petrol,
        orElse: () => null,
      );
      if (find != null) petrol.removeAt(petrol.indexOf(find));
    });
  }

  ///on add form
  void onAddForm() {
    setState(() {
      var _petrol = Petrol();
      petrol.add(ReportGenerator(
        petrol: _petrol,
        onDelete: () => onDelete(_petrol),
      ));
    });
  }

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