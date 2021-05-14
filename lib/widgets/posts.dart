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

  @override
  _PostState createState() => _PostState(
    postId: this.postId,
    ownerId: this.ownerId,
    username: this.username,
    location: this.location,
    description: this.description,
    mediaUrl: this.mediaUrl,
    likes: this.likes,
    //likeCount:getLikeCount(likes),
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

  String postPhotoUrl;
  Future fetchProfilePicture(owid) async {
    //fetch userid of the peson who posted it
    //find the profile photo of the person

    await FirebaseFirestore.instance.collection('users')
        .where('uid', isEqualTo:owid)
        .get()
        .then((value){
      value.docs.forEach((result) {
        setState(() {
          postPhotoUrl= result.data()['photoUrl'];
        });


      });
    });

  }

  buildPostHeader(currentUsername) {
    // String userId = getCurrentUser();
        return ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            backgroundImage:
             postPhotoUrl!='' || postPhotoUrl!= null?
            NetworkImage(postPhotoUrl??"")
             :AssetImage('assets/images/user.png'),
            // CachedNetworkImageProvider(
            //   widget.currentUser.photoURL
            // ),
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
              deletePost(postId);
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
                print('up-voting post');
                myVote!=1?
                vote(postId,1):myVote==1?vote(postId,0):null;
              //  adds number of likes to the post
              //  creates a subcollection of human upvoters with the user id
              },
              child: Icon(
                Icons.arrow_circle_up,
                size: 28.0,
                color: myVote==1?Colors.blue:Colors.grey,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),

            GestureDetector(
              onTap: (){
                print('down-voting post');

                myVote!=2?
                vote(postId,2):myVote==2?vote(postId,0):null;
               // checkUpVote(postId);
                //  adds number of likes to the post
                //  creates a subcollection of human upvoters with the user id or creates a list of likers with the user ids inside
              },
              child: Icon(
                Icons.arrow_circle_down,
                size: 28.0,
                color: myVote==2?Colors.blue:Colors.grey,
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
                    color: Colors.grey,
                  ),
                  onPressed: (){

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CommentsDisplay(postId: postId)),
                    );
                  }
              ),
            ),
          //  add comment count here
            SizedBox(width:10),
            Text(commentCount.toString()+' comments'),
          ],
        ),
        Row(
          children: [
            Container(
              // margin: EdgeInsets.only(left: 20.0),
              child:StreamBuilder<QuerySnapshot>(
                // <2> Pass `Stream<QuerySnapshot>` to stream
                  stream: FirebaseFirestore.instance.collection('posts')
                      .where('postId', isEqualTo: postId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    Widget mywidget;
                    if (snapshot.hasData) {
                      // <3> Retrieve `List<DocumentSnapshot>` from snapshot
                      final List<DocumentSnapshot> documents = snapshot.data.docs;
                      mywidget=ListView(
                          children: documents
                              .map((doc) => Center(
                            child: Text(doc['votesCount'].toString() + ' votes'),

                            ),
                          )
                              .toList());
                    } else if (snapshot.hasError) {
                     mywidget=  Text("It's Error!");
                      }
                    return Container(
                        height:30,
                        margin: EdgeInsets.only(left:20),
                        width:50,
                        child: mywidget);
                      }
                      )
                )

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
            SizedBox(width: 5),
            Expanded(child: Text('$description')),
          ],
        ),
      ],
    );
  }
  String pUsername = '';
  int myVote=0;
  String voteCount='0';
  int commentCount=0;
  bool inExistence=true;
  @override
  void initState()  {
    super.initState();
    _username();
    checkPostExistence(postId);
    fetchProfilePicture(ownerId);
    checkUpVote(postId);
    getVoteCount(postId);
    getCommentCount(postId);

  }
  checkPostExistence(pid) async{
    //instead of refreshing page when post is deleted, it MAY check if post still exists in firebase
    //and if not the will not be displayed
    await FirebaseFirestore.instance.collection('posts')
        .where('postId', isEqualTo:pid)
        .get()
        .then((value){
      value.docs.forEach((result) {
        setState(() {
          inExistence=true;
        });

      });
    }).catchError((err){
      print(err.message);
      setState(() {
        inExistence=false;
      });
    });
  }
  getCommentCount(postId) async{
    FirebaseFirestore.instance.collection('comments')
        .where('postId', isEqualTo: postId)
        .get().then((value) {
          setState(() {
           commentCount= value.docs.length;
          });
  });
  }
  Future<String> _username() async {
    final SharedPreferences _sp = await SharedPreferences.getInstance();
    setState(() {
      pUsername= _sp.get("username");
    });
    return _sp.get("username");
  }

  Future<String>getVoteCount(postId) async {
   await FirebaseFirestore.instance.collection('posts').doc(postId)
        .collection('votes')
    .where('postId', isEqualTo:postId)
        .get()
        .then((value){
      value.docs.forEach((result) {
        setState(() {
          voteCount= result.data()['votesCount'];
        });

        return result.data()['voteCount'];
      });
    });
  }

 Future<String>countVote(postId) async {
    FirebaseFirestore.instance.collection('posts').doc(postId)
    .collection('votes')
    .get()
    .then((value){
      return value.docs.length.toString();
    });
  }

 checkUpVote(postId) async{
   String usid = await getCurrentUser();
   await FirebaseFirestore.instance.collection("posts").doc(postId)
       .collection('votes')
       .where('userId', isEqualTo: usid)
       .get().then((querySnapshot) {
     querySnapshot.docs.forEach((result) {

           //fetch the number under 'vote'
          print('------------------------------------------------------------');
           print(result.data()['vote']);
          print('------------------------------------------------------------');
          setState(() {
            myVote= result.data()['vote'];
          });

     });
   });
 }

  Future<void> vote(postId, val) async {
    //check if post has been upvoted before

    setState(() {
      myVote=val;
    });
    String uid = await getCurrentUser();
    CollectionReference upVotes = FirebaseFirestore.instance.collection('posts').doc(postId).collection('votes');
    return upVotes.doc(uid)
        .set({
      'userId': uid,
      'vote': myVote
    })
        .then((value) {
      print("Post Upvoted");
       addVotes(postId, val);
    } )
        .catchError((error) => print("Failed to delete upvote: $error"));
  }
addVotes(postId,val) async{

    int totalupVotes,totaldownVotes,finalVote;
    // checkUpVote(postId);
  FirebaseFirestore.instance.collection('posts').doc(postId)
      .collection('votes')
      .where('vote', isEqualTo: 1)
      .get()
      .then((upvotes){
    FirebaseFirestore.instance.collection('posts').doc(postId)
        .collection('votes')
        .where('vote', isEqualTo: 2)
        .get().then((downvotes) {
          totaldownVotes = downvotes.docs.length;
          totalupVotes= upvotes.docs.length;

          finalVote= totalupVotes- totaldownVotes;
          CollectionReference post = FirebaseFirestore.instance.collection('posts');
          post.doc(postId).update({
            'votesCount': finalVote
          });


    });
  });


}

  @override
  Widget build(BuildContext context)  {
    return pUsername==''?
        Center(child:CircularProgressIndicator())
        :inExistence==true?Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildPostHeader(pUsername),
        buildPostImage(),
        buildPostFooter(),
      ],
    ):SizedBox(height:0);
  }
}

