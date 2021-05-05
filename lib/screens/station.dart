import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ola_energy/models/user.dart' as UserModel;
import 'package:ola_energy/screens/login.dart' as prefix;
import 'package:ola_energy/screens/newsDetails.dart';
import 'package:ola_energy/screens/registration.dart';
import 'package:ola_energy/widgets/posts.dart';
import 'package:ola_energy/widgets/progress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

final databaseReference = FirebaseFirestore.instance;

class Upload extends StatefulWidget {
  final User currentUser;
  //final String profileId;

  Upload({this.currentUser,});

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> with AutomaticKeepAliveClientMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  File file;
  bool isUploading = false;
  String postId = Uuid().v4();
  bool isLoading = false;
  int postCount = 0;
  List<Post> posts = [];

  // @override
  // void initState() {
  //   super.initState();
  //   //   getProfilePosts();
  // }

  // getProfilePosts() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   QuerySnapshot snapshot =
  //       await postsRef.orderBy('timestamp', descending: true).get();
  //   setState(() {
  //     isLoading = false;
  //     postCount = snapshot.docs.length;
  //     posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
  //   });
  // }

  handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = file;
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create Post"),
            children: <Widget>[
              SimpleDialogOption(
                  child: Text("Photo with Camera"),
                  onPressed: handleTakePhoto),
              SimpleDialogOption(
                  child: Text("Image from Gallery"),
                  onPressed: handleChooseFromGallery),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  Container buildSplashScreen() {
    return Container(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Updates"),
              backgroundColor: Color(0xff07239d),
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 1.0,
              onPressed: () {
                selectImage(context);
              },
              backgroundColor: Color(0xff07239d),
              child: Icon(Icons.add),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream:
                  postsRef.orderBy('timestamp', descending: true).snapshots(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.hasError) {
                  return Text("Error!");
                } else if (asyncSnapshot.data == null) {
                  return Text("No Posts!");
                } else if (asyncSnapshot.hasData) {
                  print("DATA CHUNK LENGTH ${asyncSnapshot.data.docs.length}");
                  return
                    ListView.builder(
                      itemCount: asyncSnapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        UserModel.User data = UserModel.User.fromDocument(asyncSnapshot.data.docs[index]);
                        return Post(
                          postId:asyncSnapshot.data.docs[index].id ,
                          ownerId: data.uid,
                          username: data.username,
                          location: data.location,
                          description: data.description,
                          mediaUrl: data.photoUrl,
                          likes: data.likes,
                        );
                          //Text(posts.toString());

                      });
                } else if (!asyncSnapshot.hasData) {
                  return circularProgress();
                }
                return null;
              },
            )
        ));
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  //make image fit well
  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask =
        prefix.storageRef.child('post_$postId.jpg').putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  CollectionReference post = FirebaseFirestore.instance.collection('posts');

  createPostInFirestore(
      {String username, String mediaUrl, String location, String description}) {
    return postsRef
        .add({
          'postId': postId,
          'ownerId': firebaseAuth.currentUser.uid,
          'username': username,
          'mediaUrl': mediaUrl,
          'description': description,
          'location': location,
          'timestamp': timestamp,
          'likes': {},
        })
        .then((value) => print('image added'))
        .catchError((error) => print('failed to add user: $error'));
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    Future<String> _username() async {
      final SharedPreferences _sp = await SharedPreferences.getInstance();
      return _sp.get("username");
    }

    ;
    await compressImage();
    String mediaUrl = await uploadImage(file);
    String _userName = await _username();
    createPostInFirestore(
      username: _userName,
      mediaUrl: mediaUrl,
      location: locationController.text,
      description: captionController.text,
    );
    captionController.clear();
    locationController.clear();
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff07239d),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: clearImage,
        ),
        title: Text(
          'Caption Post',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          FlatButton(
            onPressed: isUploading
                ? null
                : () {
                    handleSubmit();
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> Post()));
                  },
            child: Text(
              'Post',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? linearProgress() : Text(''),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/m1.jpeg'),
              // CachedNetworkImageProvider(
              //   widget.currentUser.photoURL
              // ),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                  hintText: 'Write a caption...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Color(0xff07239d),
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: 'Where was this photo taken?',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: 200.0,
            height: 100.0,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              onPressed: () => getUserLocation(),
              label: Text(
                'Use Current Location',
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Color(0xff07239d),
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, '
        '${placemark.subLocality} ${placemark.locality}, '
        '${placemark.subAdministrativeArea}, ${placemark.administrativeArea} '
        '${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress =
        "${placemark.subLocality}, ${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
  }
}
