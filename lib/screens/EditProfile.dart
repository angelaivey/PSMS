import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/login.dart' as login;
import '../screens/registration.dart';
import '../screens/settings.dart';
import '../widgets/progress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class Settings extends StatelessWidget {
  final String profileId;

  Settings({this.profileId});

  @override
  Widget build(BuildContext context) {
    // Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditProfile(),
    );
  }
}
//}

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool showPassword = false;
  String employeeId;
  String userEmail;
  String accType;
  String stationId = '';
  String photoUrl = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController stationIdController = TextEditingController();

  CollectionReference dbRef = FirebaseFirestore.instance.collection('users');
  @override
  void initState() {
    super.initState();
    storedData();
  }

  Future storedData() async {
    final SharedPreferences _sp = await SharedPreferences.getInstance();
    print("Fetched from shared p ${_sp.getString("employeeId")}");
    setState(() {
      employeeId = _sp.getString("employeeId");
      userEmail = _sp.getString("email");
      accType = _sp.getString('accType');
      // stationId = _sp.getString("stationId");
      _fetchProfilePicture(_sp.getString("employeeId"));
      _fetchstationId(_sp.getString("employeeId"));
      print("Fetched from shared p ${_sp.getString("employeeId")}");
    });
  }

  _fetchstationId(employeeId) async {
    //instead of refreshing page when post is deleted, it MAY check if post still exists in firebase
    //and if not the will not be displayed
    await FirebaseFirestore.instance
        .collection('users')
        .where('employeeId', isEqualTo: employeeId)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        setState(() {
          stationId = result.data()['stationId'];
          //accType = result.
        });
      });
    }).catchError((err) {
      print(err.message);
    });
  }

  _fetchProfilePicture(employeeId) async {
    //instead of refreshing page when post is deleted, it MAY check if post still exists in firebase
    //and if not the will not be displayed
    await FirebaseFirestore.instance
        .collection('users')
        .where('employeeId', isEqualTo: employeeId)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        setState(() {
          photoUrl = result.data()['photoUrl'];
        });
      });
    }).catchError((err) {
      print(err.message);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      emailController.text = userEmail;
      nameController.text = employeeId;
      stationIdController.text = stationId;
    });
  }

  File _image;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      final picker = ImagePicker();
      var image = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image.path);
        print('image path $_image');
      });
    }

    String _photoUrl = '';

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     }),
        backgroundColor: Color(0xff322C40),
        title: Text('My Profile'),
      ),
      body: photoUrl != ""
          ? Container(
              padding: EdgeInsets.only(left: 16, top: 25, right: 16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  children: [
                    buildTextField(
                        "Employee Id", employeeId, nameController, false),
                    buildTextField(
                        "Account Type", accType, nameController, false),
                    buildTextField(
                        "Work E-mail", userEmail, emailController, false),
                    // buildTextField("Password", "********", true),
                    buildTextField(
                        "Station", stationId, stationIdController, false),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Change Password',
                              style: TextStyle(fontSize: 17.0),
                            ),
                            Icon(
                              Icons.chevron_right,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePassword()));
                        }),
                    SizedBox(
                      height: 35,
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Container(
              height: 15,
              width: 15,
              child: SpinKitRotatingCircle(
                color: Color(0xff322C40),
                size: 40.0,
              ),
            )),
    );
  }

  bool isAuth = false;

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      print("User signed in!: $account");
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  logout() {
    googleSignIn.signOut();
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget buildTextField(String labelText, String placeholder,
      TextEditingController controller, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        obscureText: isPasswordTextField ? showPassword : false,
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool match = true;
  int errorCode = 0;

  String userEmail;

  Future reauth(String oldPassword) async {
    final SharedPreferences _sp = await SharedPreferences.getInstance();
    setState(() {
      userEmail = _sp.getString("email");
    });
    // Prompt the user to enter their email and password
    String email = _sp.getString("email");
    String password = oldPassword;

// Create a credential
    EmailAuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);

// Reauthenticate
    await FirebaseAuth.instance.currentUser
        .reauthenticateWithCredential(credential)
        .then((value) {
      _changePassword(
          newPasswordController.text, confirmPasswordController.text);
    }).catchError((err) {
      Fluttertoast.showToast(
          msg: err.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  void _changePassword(String password, String confirmPassword) async {
    if (password == confirmPassword) {
      print(password.length);
      if (password.length >= 8) {
        User user = await FirebaseAuth.instance.currentUser;

        //Pass in the password to updatePassword.
        user.updatePassword(password).then((_) {
          Fluttertoast.showToast(
              msg: 'Successfully changed password',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xff322C40),
              textColor: Colors.white,
              fontSize: 16.0);
          print("Successfully changed password");
          Navigator.pop(context);
        }).catchError((error) {
          print("Password can't be changed" + error.toString());
          //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
        });
      } else {
        setState(() {
          errorCode = 1;
        });
      }
    }
    //Create an instance of the current user.
    else {
      setState(() {
        match = false;
      });
    }
  }

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff322C40),
          title: Text('Change Password'),
        ),
        body: Column(children: [
          TextField(
            controller: oldPasswordController,
            obscureText: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true,
                hintText: 'Old Password'),
          ),
          SizedBox(
            height: 25,
          ),
          TextField(
            controller: newPasswordController,
            obscureText: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true,
                hintText: 'New Password'),
          ),
          SizedBox(
            height: 25,
          ),
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true,
                hintText: 'Confirm Password'),
          ),
          SizedBox(
            height: 35,
          ),
          match == true
              ? SizedBox(height: 0)
              : Text(
                  errorCode == 0
                      ? 'Passwords do not match'
                      : 'Password too short. Should be more than 8 characters long',
                  style: TextStyle(color: Colors.red)),
          match == true ? SizedBox(height: 0) : SizedBox(height: 35),
          FlatButton(
            color: Color(0xff322C40),
            textColor: Colors.white,
            height: 40,
            minWidth: 120,
            onPressed: () {
              reauth(oldPasswordController.text);
            },
            child: Text(
              'Change Password',
              style: TextStyle(fontSize: 15.0),
            ),
          ),
        ]));
  }
}
