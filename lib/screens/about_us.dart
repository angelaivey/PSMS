import 'package:flutter/material.dart';
import 'DashBoard.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('About us')
        ],
      ),
    );
  }
}
