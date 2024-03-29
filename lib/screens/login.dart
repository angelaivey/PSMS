import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/DashBoard.dart';
import '../screens/HomePage.dart';
import '../screens/HomeState.dart';
import '../screens/registration.dart';
import '../widgets/bezierContainer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final storageRef = FirebaseStorage.instance.ref();
final _formKey = GlobalKey<FormState>();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("Users");

final DateTime timestamp = DateTime.now();

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //sign in with google
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  void storedData(name, email, photoUrl, uid, accType, stationId) async {
    final SharedPreferences _sp = await SharedPreferences.getInstance();
    _sp.setString("employeeId", name.toString());
    _sp.setString("email", email.toString());
    _sp.setString("photoUrl", photoUrl.toString());
    _sp.setString("uid", uid.toString());
    _sp.setString("stationId", stationId);
    _sp.setString("accType", accType);
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    //detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    //Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      print("User signed in!: $account");
      setState(() {
        isAuth = true;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  signIn() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  buildAuthScreen() {
    return HomePage();
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: emailError ? Color(0xffFC6161) : Color(0xfff3f3f4),
                filled: true),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
        onTap: () {
          checkEmpty(emailController.text, passwordController.text);
          if (emailError == false && passwordError == false) {
            logInToFb();
          }
        },
        // onTap: () {
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (context) {
        //     return HomePage();
        //   }));
        // },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xff322C40), Color(0xff322C40)],
            ),
          ),
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return isAuth
        ? buildAuthScreen()
        : GestureDetector(
            onTap: () {
              signIn();
            },
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff1959a9),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            topLeft: Radius.circular(5)),
                      ),
                      alignment: Alignment.center,
                      child: Text('G',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff2872ba),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(5),
                            topRight: Radius.circular(5)),
                      ),
                      alignment: Alignment.center,
                      child: Text('Sign in with Google',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Register',
            style: TextStyle(
                color: Color(0xffC6BB72),
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
      //),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'OLA',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xff322C40),
          ),
          children: [
            TextSpan(
              text: 'ENERGY',
              style: TextStyle(color: Color(0xff7A7974), fontSize: 30),
            ),
          ]),
    );
  }

  bool obsecureText = true;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(height: 50),
                  _entryField("Email id", emailController),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: height * .015,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: height * 0.0655,
                                child: TextField(
                                    controller: passwordController,
                                    obscureText: obsecureText,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: passwordError
                                            ? Color(0xffFC6161)
                                            : Color(0xfff3f3f4),
                                        filled: true)),
                              ),
                            ),
                            Container(
                              height: height * 0.0655,
                              color: Color(0xfff3f3f4),
                              padding: EdgeInsets.only(left: 5, right: 10),
                              child: GestureDetector(
                                onTapDown: (param) {
                                  //param is never used
                                  setState(() {
                                    obsecureText = !obsecureText;
                                  });
                                },
                                onTapUp: (param) {
                                  //param is never used
                                  setState(() {
                                    obsecureText = !obsecureText;
                                  });
                                },
                                child: Icon(
                                  obsecureText
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  _submitButton(),
                  // Container(
                  //   padding: EdgeInsets.symmetric(vertical: 10),
                  //   alignment: Alignment.centerRight,
                  //   child: Text('Forgot Password ?',
                  //       style: TextStyle(
                  //           fontSize: 14, fontWeight: FontWeight.w500)),
                  // ),
                  _divider(),
                  _facebookButton(),
                  SizedBox(height: height * .055),
                  GestureDetector(
                    onTap: (){
                       Navigator.of(context).pushReplacement(
                       MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: _createAccountLabel()),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }

  bool passwordError = false;
  bool emailError = false;
  void checkEmpty(email, password) {
    if (password == "" || password == null) {
      setState(() {
        passwordError = true;
      });
    }

    if (email == "" || email == null) {
      setState(() {
        emailError = true;
      });
    } else {
      toTrue();
    }
  }

  void toTrue() {
    passwordError = false;
    emailError = false;
    print('should be working on it');
  }

  void logInToFb() {
    firebaseAuth
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseAuth.currentUser.uid)
          .get()
          .then((DocumentSnapshot value) {
        print("Data Chunk ${value}");

        final String employeeId = value["employeeId"];
        final String userEmail = value["email"];
        final String accType = value["accountType"];
        final String stationId = value["stationId"];
        // final String userPhoto =  value["photoUrl"]!=null?null:value['photoUrl'];
        final String uid = value["uid"];
        print("User data : $employeeId $userEmail");
        storedData(employeeId, userEmail, uid, 'assets/images/user.png',
            accType, stationId);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashBoard()),
          ModalRoute.withName('/'),
        );
      });
    }).catchError((err) {
      print(err.message);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }
}
