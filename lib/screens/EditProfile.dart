import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ola_energy/screens/login.dart' as login;
import 'package:ola_energy/screens/registration.dart';
import 'package:ola_energy/screens/settings.dart';
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
  String userName;
  String userEmail;
  String userLocation;
  String photoUrl;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  CollectionReference dbRef = FirebaseFirestore.instance.collection('users');

  Future storedData() async {
    final SharedPreferences _sp = await SharedPreferences.getInstance();
    print("Fetched from shared p ${_sp.getString("username")}");
    setState(() {
      userName = _sp.getString("username");
      userEmail = _sp.getString("email");
      userLocation = _sp.getString("location");
      photoUrl = _sp.getString("photoUrl");
      print("Fetched from shared p ${_sp.getString("username")}");
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      emailController.text = userEmail;
      nameController.text = userName;
      locationController.text = userLocation;
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

    Future<String> uploadImage(imageFile) async {
      UploadTask uploadTask = storageRef
          .child('profilepics/${_image.path.split("/").last}')
          .putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        _photoUrl = downloadUrl;
      });
      return downloadUrl;
    }

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     }),
        backgroundColor: Color(0xff322C40),
        title: Text('Edit Profile'),
      ),

      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (_image != null)
                                ? FileImage(
                                    File(_image.path),
                                  )
                                : photoUrl == ""
                                    ? Icon(Icons.person)
                                    : NetworkImage(photoUrl),
                          )),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Color(0xff322C40),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              getImage();
                            },
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              buildTextField("Full Name", userName, nameController, false),
              buildTextField("E-mail", userEmail, emailController, false),
              // buildTextField("Password", "********", true),
              buildTextField("Station", userLocation, locationController, false),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Change Password',
                      style: TextStyle(
                        fontSize: 17.0
                      ),),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      String imageUrl = await uploadImage(_image);
                      dbRef.doc(firebaseAuth.currentUser.uid).update({
                        'uid': firebaseAuth.currentUser.uid,
                        'location': locationController.text == ''
                            ? userLocation
                            : locationController.text,
                        'username': nameController.text == ''
                            ? userName
                            : nameController.text,
                        'email': emailController.text == ''
                            ? userEmail
                            : emailController.text,
                        'photoUrl': imageUrl,
                      }).then((value) async {
                        print('updated');
                        final SharedPreferences _sp =
                            await SharedPreferences.getInstance();
                        _sp.setString("photoUrl", imageUrl);
                        Fluttertoast.showToast(
                            msg: 'Profile updated',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color(0xff322C40),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }).catchError((onError) {
                        Fluttertoast.showToast(
                            msg: "Error: $onError",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        print(onError.toString());
                      });
                    },
                    color: Color(0xff322C40),
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: OutlineButton(
                  color: Color(0xff322C40),
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    logout();
                    signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => login.LoginPage()));
                  },
                  child: Text("SIGN OUT",
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 2.2,
                          color: Colors.black)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    storedData();

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
