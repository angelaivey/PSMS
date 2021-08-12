import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/DashBoard.dart';
import 'screens/WelcomePage.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
     Map<int, Color> color =
        {
        50:Color.fromRGBO(255,50,44, .1),
        100:Color.fromRGBO(255,50,44, .2),
        200:Color.fromRGBO(255,50,44, .3),
        300:Color.fromRGBO(255,50,44, .4),
        400:Color.fromRGBO(255,50,44, .5),
        500:Color.fromRGBO(255,50,44, .6),
        600:Color.fromRGBO(255,50,44, .7),
        700:Color.fromRGBO(255,50,44, .8),
        800:Color.fromRGBO(255,50,44, .9),
        900:Color.fromRGBO(255,50,44, 1),
        };
    MaterialColor myColor = MaterialColor(0xff322C40,color);
   

    return (
       MaterialApp(
        title: 'Ola Energy',
        theme: ThemeData(
          primarySwatch: myColor,
          textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
            bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: FirebaseAuth.instance.currentUser?.uid != null? DashBoard():
        WelcomePage(),
      )
    );
  }
}