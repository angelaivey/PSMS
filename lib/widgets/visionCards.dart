import 'package:flutter/material.dart';
import 'dart:math';

class VisionCard extends StatefulWidget {
  @override
  _VisionCardState createState() => _VisionCardState();
}

class _VisionCardState extends State<VisionCard> {

  //for the flipping cards
  bool isBack = true;
  double angle = 0;

  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _flip,
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: angle),
              duration: Duration(seconds: 1),
              builder: (BuildContext context, double val, _){
                if (val >= (pi / 2)) {
                  isBack = false;
                } else {
                  isBack = true;
                }
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(val),
                  child: Container(
                    width: 250,
                    height: 250,
                    color: Colors.white60,
                    child: isBack ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: AssetImage('assets/images/vision.jpg'),
                          )
                      ),
                    ) : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(pi),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text('To be the downstream marketer of choice in shaping African energy and empowering African born prosperity.',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MissionCard extends StatefulWidget {
  @override
  _MissionCardState createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> {

  //for the flipping cards
  bool isBack = true;
  double angle = 0;

  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _flip,
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: angle),
              duration: Duration(seconds: 1),
              builder: (BuildContext context, double val, _){
                if (val >= (pi / 2)) {
                  isBack = false;
                } else {
                  isBack = true;
                }
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(val),
                  child: Container(
                    width: 250,
                    height: 250,
                    color: Colors.white60,
                    child: isBack ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: AssetImage('assets/images/mission.png'),
                          )
                      ),
                    ) : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(pi),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text('Delighting our customers by delivering high quality products and services through energized teams and valuable partnerships, driving growth and ensuring good returns for all stakeholders.',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ValuesCard extends StatefulWidget {
  @override
  _ValuesCardState createState() => _ValuesCardState();
}

class _ValuesCardState extends State<ValuesCard> {

  //for the flipping cards
  bool isBack = true;
  double angle = 0;

  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _flip,
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: angle),
              duration: Duration(seconds: 1),
              builder: (BuildContext context, double val, _){
                if (val >= (pi / 2)) {
                  isBack = false;
                } else {
                  isBack = true;
                }
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(val),
                  child: Container(
                    width: 250,
                    height: 250,
                    color: Colors.white60,
                    child: isBack ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: AssetImage('assets/images/values.jpg'),
                          )
                      ),
                    ) : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(pi),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(' Safety & Health \n Service Excellence \n Commitment to quality \n Social Responsibility \n Pursuing Excellence',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
