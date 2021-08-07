import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/login.dart';
import '../screens/registration.dart';
import '../widgets/bezierContainer.dart';


class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  Widget _logo() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/ola_logo.jpg'),
      ),

    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) {
          return LoginPage();
        }));
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5),),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black.withAlpha(100),
                  offset: Offset(1, 3),
                  blurRadius: 3,
                  spreadRadius: 1)
            ],
            color: Colors.white
        ),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Color(0xfff7892b)),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withAlpha(100),
                offset: Offset(1, 3),
                blurRadius: 3,
                spreadRadius: 1)
          ],
          // border: Border.all(color: Color(0xff4d94ff), width: 2),
            color: Color(0xff4d94ff)
        ),
        child: Text(
          'Register now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  // Widget _label() {
  //   return Container(
  //       margin: EdgeInsets.only(top: 40, bottom: 20),
  //       child: Column(
  //         children: <Widget>[
  //           Text(
  //             'Quick login with Touch ID',
  //             style: TextStyle(color: Colors.white, fontSize: 17),
  //           ),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           Icon(Icons.fingerprint, size: 90, color: Colors.white),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           Text(
  //             'Touch ID',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 15,
  //               decoration: TextDecoration.underline,
  //             ),
  //           ),
  //         ],
  //       ));
  // }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'OLA',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme
                .of(context)
                .textTheme
                .display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: 'ENERGY',
              style: TextStyle(color: Color(0xff4d94ff), fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -MediaQuery.of(context).size.height * .15,
            right: -MediaQuery.of(context).size.width * .2,
            bottom: -MediaQuery.of(context).size.height * .12,
            left: -MediaQuery.of(context).size.width * .3,
            child: BezierContainer(),
          ),
          SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery
                .of(context)
                .size
                .height,
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.all(Radius.circular(5)),
            //     // boxShadow: <BoxShadow>[
            //     //   BoxShadow(
            //     //       color: Colors.grey.shade200,
            //     //       offset: Offset(2, 4),
            //     //       blurRadius: 5, //
            //     //       spreadRadius: 2)
            //     // ],
            //     // gradient: LinearGradient(
            //     //     begin: Alignment.topRight,
            //     //     end: Alignment.topLeft,
            //     //     colors: [Color(0xffe46b10), Color(0xff4d94ff)])
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'WELCOME',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'TO',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                SizedBox(
                height: 40,
              ),
              _title(),
              SizedBox(
                height: 80,
              ),
              _submitButton(),
              SizedBox(
                height: 20,
              ),
              _signUpButton(),
              SizedBox(
                height: 20,
              ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

