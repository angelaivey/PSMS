import 'package:cloud_firestore/cloud_firestore.dart';

class Sales {
  final int lube;
  final int lpg;
  final int fuel;
  Timestamp date;
  // final String salesMonth;
  // final String colorValue;

  Sales(this.lpg, this.lube, this.fuel, this.date);

  Sales.fromMap(Map<String, dynamic> map)
  : assert(map['lube'] != null),
    assert(map['lpg'] != null),
    assert(map['fuel'] != null),
    assert(map['date'] != null),
      lpg = map['lpg'],
      lube = map['lube'],
      fuel = map['fuel'],
      date = map['date'];

  //print from firebase
  @override
  String toString() {
    // TODO: implement toString
    //return super.toString();
    return 'Record<$lube: $lpg: $fuel: $date>';
  }
}