// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../screens/login.dart';
// import '../widgets/posts.dart';
// import '../widgets/progress.dart';
// import 'station.dart';
//
// class Updates extends StatefulWidget {
//   final FirebaseFirestore fb = FirebaseFirestore.instance;
//
//   @override
//   _UpdatesState createState() => _UpdatesState();
// }
//
// class _UpdatesState extends State<Updates> {
//
//   bool isLoading = false;
//   int postCount = 0;
//   List<Post> posts = [];
//
//
//   @override
//   void initState() {
//     super.initState();
//     getProfilePosts();
//   }
//
//   getProfilePosts() async {
//     setState(() {
//       isLoading = true;
//     });
//     QuerySnapshot snapshot = await postsRef.doc()
//         .collection('posts')
//         .orderBy('timeStamp', descending: true)
//         .get();
//     setState(() {
//       isLoading = false;
//       postCount = snapshot.docs.length;
//       posts = snapshot.docs.map((doc) => Post.fromDocument(doc))
//           .toList();
//     });
//   }
//
//   buildProfilePosts(){
//     //displaying posts after fetching them
//     if(isLoading){
//       return circularProgress();
//     }
//     return Column(
//       children: posts,
//     );
//   }
//
//   // Container buildSplashScreen() {
//   //   return Container(
//   //     child: Scaffold(
//   //       floatingActionButton: FloatingActionButton(
//   //         onPressed: (){
//   //           //selectImage(context);
//   //         },
//   //       ),
//   //       body: Container(
//   //         //padding: ,
//   //       ),
//   //     ),
//   //   );
//   //
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Updates page'),
//       ),
//       body: ListView(
//         children: [
//           buildProfilePosts(),
//         ],
//       ),
//     );
//   }
//
// }
