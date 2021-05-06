import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ola_energy/models/user.dart';
import 'package:ola_energy/screens/HomePage.dart';
import 'package:ola_energy/screens/comments.dart';
import 'package:ola_energy/screens/login.dart';
import 'package:ola_energy/screens/registration.dart';
import 'package:ola_energy/widgets/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;

  Post({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
});

  int getLikeCount(likes){
    //if there are no likes, return 0
    if(likes == null){
      return 0;
    }
    int count = 0;
    likes.values.forEach((val){
      if (val == true){
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostState createState() => _PostState(
    postId: this.postId,
    ownerId: this.ownerId,
    username: this.username,
    location: this.location,
    description: this.description,
    mediaUrl: this.mediaUrl,
    likes: this.likes,
    likeCount:getLikeCount(likes),
  );
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  int likeCount;
  Map likes;

  _PostState({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    this.likeCount,
  });


  buildPostHeader(currentUsername) {
    // String userId = getCurrentUser();
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/m1.jpeg'),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: (){
              print('showing profile');
              },
            child: Text(
              username,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(location),
          trailing:
          //    if ownerId == uid proceed else null
          username==currentUsername?
          IconButton(
            onPressed: (){
              print("meeehhhehehehheheheh");
              deletePost(postId);
              // unafaa kurefresh
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>Post(postId: postId,ownerId: ownerId,username:username,location:location,description: description,likes:likes)));
              Navigator.push(context, MaterialPageRoute(builder: (context) => page2())).then((value) {
                setState(() {
                  // refresh state
                });
              });
            },
            icon: Icon(Icons.delete),
          ): null ,
        );


  }

  buildPostImage(){
    return GestureDetector(
      onDoubleTap: (){
        print ('liking post');
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          //(mediaUrl == null) ? Image.asset('assets/images/m1.jpeg') : NetworkImage(mediaUrl)
          Image.network(mediaUrl),
        ],
      ),
    );
  }
  likePost(isLiked,userId,postId)
  {
    if(isLiked=true){
    //  remove the user id from the liked posts dictionary
    }
    bool liked= !isLiked;
  }

  //deletePost(postId){
    CollectionReference users = FirebaseFirestore.instance.collection('posts');

    Future<void> deletePost(postId) {
      return users
          .doc(postId)
          .delete()
          .then((value) => print("Post Deleted"))
          .catchError((error) => print("Failed to delete post: $error"));
    }
 // }

  buildPostFooter(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: (){

                print('liking post');
              },
              child: Icon(
                Icons.thumb_up_alt_outlined,
                size: 28.0,
                color: Colors.blue,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: (){
                print('showing comments');
              },
              child: IconButton(
                  icon: Icon(Icons.comment_outlined,
                    size: 28.0,
                    color: Colors.blue,
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CommentsDisplay()),
                    );
                  }
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                '$likeCount likes',
                style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                '$username',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(child: Text('$description')),
          ],
        ),
      ],
    );
  }
  String pUsername = '';
  @override
  void initState()  {
    super.initState();
    // DO YOUR STUFF
    _username();
  }

  Future<String> _username() async {
    final SharedPreferences _sp = await SharedPreferences.getInstance();
    setState(() {
      pUsername= _sp.get("username");
    });
    return _sp.get("username");
  }


  @override
  Widget build(BuildContext context)  {
    return pUsername==''?
        Center(child:CircularProgressIndicator())
        :Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildPostHeader(pUsername),
        buildPostImage(),
        buildPostFooter(),
      ],
    );
  }
}
class page2 extends StatefulWidget {
  
  @override
  _page2State createState() => _page2State();
}

class _page2State extends State<page2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Nothing to see here'),
      ),
    );
  }
}
