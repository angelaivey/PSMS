import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ola_energy/screens/DashBoard.dart';
import 'package:ola_energy/screens/HomePage.dart';
import 'package:ola_energy/screens/HomeState.dart';
import 'package:ola_energy/widgets/bezierContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

final _formKey = GlobalKey<FormState>();
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

final databaseReference = FirebaseFirestore.instance;

final storageRef = FirebaseStorage.instance.ref();
DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("Users");
TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController locationController = TextEditingController();


class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

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

  Widget _entryField(String title,TextEditingController controller, {bool isPassword = false}) {
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
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }


  Future<void> createRecord()async {
    //create a user with a specific uid
    //create users with auth
    String uid = await getCurrentUser();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return users.doc(uid)
        .set({
      'uid': uid,
      'username': nameController.text,
      'email': emailController.text,
      'location': locationController.text,
    }).then((value) => print('user added'))
        .catchError((error)=> print('failed to add user: $error'));
  }


  Widget _submitButton() {
    return InkWell(
      onTap: () async {

        if(_formKey.currentState.validate()){
          registerToFb();
        }
        //createRecord();
      },
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
              colors: [Color(0xff322C40), Color(0xff322C40)])),
      child: Text(
        'Register Now',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ));
  }

  Widget _loginAccountLabel() {
    // return InkWell(
    //   onTap: () {
    //     Navigator.push(
    //         context, MaterialPageRoute(builder: (context) => LoginPage()
    //     ));
    //   },
      child:
      return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: (){
                Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => LoginPage()),(route)=>false);
                },
              child: Text(
                'Login',
                style: TextStyle(
                    color: Color(0xffC6BB72),
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
     // ),
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

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username",nameController),
        _entryField("Station Name",locationController),
        _entryField("Email id",emailController),
        _entryField("Password",passwordController, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -MediaQuery.of(context).size.height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .2),
                        _title(),
                        SizedBox(
                          height: 50,
                        ),
                        _emailPasswordWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        _submitButton(),
                        SizedBox(height: height * .14),
                        _loginAccountLabel(),
                      ],
                    ),
                  ),
                ),
                Positioned(top: 40, left: 0, child: _backButton()),
              ],
            ),
          ),
      ),
    );
  }
 void storedData(name,email,location)async{
    final SharedPreferences _sp = await SharedPreferences.getInstance();
    _sp.setString("username", name.toString());
    _sp.setString("email", email.toString());
    _sp.setString("location", location.toString());
  }


  void registerToFb() {
    firebaseAuth.createUserWithEmailAndPassword(email: emailController.text,
        password: passwordController.text)
        .then((result){
            createRecord();
            storedData(nameController.text, emailController.text, locationController.text);
            Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context)=>DashBoard()),
            );
          }).catchError((e){
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(e.message),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          });
    }
  }

final FirebaseAuth _auth = FirebaseAuth.instance;
getCurrentUser() async {
  final User user = await _auth.currentUser;
  final uid = user.uid;
  // Similarly we can get email as well
  //final uemail = user.email;
  print(uid);
  return uid;
  //print(uemail);
}