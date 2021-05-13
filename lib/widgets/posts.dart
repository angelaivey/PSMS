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

  // int getLikeCount(likes){
  //   //if there are no likes, return 0
  //   if(likes == null){
  //     return 0;
  //   }
  //   int count = 0;
  //   likes.values.forEach((val){
  //     if (val == true){
  //       count += 1;
  //     }
  //   });
  //   return count;
  // }

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
  @override
  void initState()  {
    super.initState();
    // DO YOUR STUFF
    _username();

    checkUpVote(postId);

    getVoteCount(postId);
    getCommentCount(postId);

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
        print('moooooooooo');
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

    // print("helooooooooooooooooooooooooooooooo");
    // print(totalVotes);
    // if(val==2){
    // //  if you clicked downvote
    //   if(myVote==2){
    //     print("downvotingggggg");
    //   //  unvote a downvote
    //     finalVote=totalVotes+1;
    //   }
    //   else if(myVote==0){
    //     print("huh");
    //     //downvote if no vote is casted
    //     finalVote=totalVotes-1;
    //   }
    //   else if(myVote==1){
    //     //downvoting if you upvoted
    //     finalVote=totalVotes-2;
    //   }
    // }
    // else if(val==1){
    // //  if human upvoted
    //   if(myVote==2){
    //     finalVote=totalVotes+2;
    //   }
    //   else if(myVote==0){
    //     finalVote=totalVotes+1;
    //   }
    //   else if(myVote==1){
    //     finalVote=totalVotes-1;
    //   }
    // }
    // else if(val==0){
    //   if(myVote==2){
    //     finalVote= totalVotes+1;
    //   }
    //   else if(myVote==1){
    //     finalVote= totalVotes-1;
    //   }
    // }
    // val==2?myVote==2?finalVote=totalVotes + 1:myVote==0?finalVote=totalVotes-1:finalVote=totalVotes-2
    //       :myVote==1?finalVote=totalVotes - 1:myVote==0?finalVote=totalVotes+1:finalVote=totalVotes+2;

  });


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
