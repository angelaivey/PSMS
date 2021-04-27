import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final Map likes;
  final String location;
  final String description;

  User({
    this.uid,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
    this.likes,
    this.location,
    this.description,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      uid: doc.data()['ownerId'],
      location: doc.data()['location'],
      email: doc.data()['email'],
      username: doc?.data()['username'] ?? "No Name",
      photoUrl: doc.data()['mediaUrl'],
      description: doc.data()['description'],
      displayName: doc.data()['displayName'],
      likes: doc.data()['likes'],
    );
  }
}