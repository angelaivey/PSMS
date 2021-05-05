import 'package:cloud_firestore/cloud_firestore.dart';

class Petrol {
  String lubes;
  String lpg;
  String fuel;
  Timestamp date;

  Petrol({this.lubes = '', this.lpg = '', this.fuel = '', this.date});
}