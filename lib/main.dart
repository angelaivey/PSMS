import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ola_energy/screens/WelcomePage.dart';
import 'package:ola_energy/screens/splash.dart';
import 'package:ola_energy/services/auth.dart';
import 'package:ola_energy/widgets/palette.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return LitAuthInit(
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Material App',
//         theme: ThemeData(
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//           textTheme: GoogleFonts.muliTextTheme(),
//           accentColor: Palette.darkOrange,
//           primarySwatch: Colors.blue,
//           appBarTheme: const AppBarTheme(
//             brightness: Brightness.dark,
//             color: Palette.darkBlue,
//           ),
//         ),
//
//         // home: const LitAuthState(
//         //   authenticated: Home(),
//         //   unauthenticated: Unauthenticated(),
//         // ),
//         home: const AuthScreen(),
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return (
       MaterialApp(
        title: 'Ola Energy',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
            bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: WelcomePage(),
      )
    );
  }
}