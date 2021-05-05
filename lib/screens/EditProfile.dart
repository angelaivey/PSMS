import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ola_energy/screens/registration.dart';
import 'package:ola_energy/screens/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Users");

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
  void initState() {
    super.initState();
    storedData();
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
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print('image path $_image');
      });
    }

    // Future uploadPic (BuildContext context) async {
    //   String fileName = basename(_image.path);
    //   Reference firebaseStorage = FirebaseStorage.instance.ref().child(fileName);
    //   UploadTask uploadTask = firebaseStorage.putFile(_image);
    //   TaskSnapshot  taskSnapshot = await uploadTask.whenComplete(() => null);
    //   setState(() {
    //     print('profile photo updated');
    //     Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile photo uploaded')));
    //   });
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff07239d),
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
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
                                ? FileImage(File(_image.path),)
                                : AssetImage('assets/images/m1.jpeg'),
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
                            color: Color(0xff07239d),
                          ),
                          child: IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: (){
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
                    onPressed: () {
                      dbRef.child(firebaseAuth.currentUser.uid.toString()).set({
                        'uid': firebaseAuth.currentUser.uid,
                        'location': locationController.text,
                        'name': nameController.text,
                        'email': emailController.text,
                        //'photoUrl': _image.toString(),
                        //'photoUrl': uploadPic(_image),
                      });
                    },
                    color: Color(0xff07239d),
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
              )
            ],
          ),
        ),
      ),
    );
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
