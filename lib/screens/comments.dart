import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ola_energy/screens/registration.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff07239d),
        title: Text('add comment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: commentController,
              minLines: 8,
              maxLines: 10,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your comment'),
            ),
            SizedBox(height: 15.0,),
            FlatButton(
              color: Color(0xff07239d),
              height: 40.0,
                minWidth: 120.0,
                child: Text('Post', style:
                  TextStyle(color: Colors.white),
                ),
              onPressed: (){
                postComment();
                Navigator.pop(context);
              }
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _username() async {
    final SharedPreferences _sp = await SharedPreferences.getInstance();
    return _sp.get("username");
  }

  Future<void> postComment()async {
    //create a user with a specific uid
    //create users with auth
    String uid = await getCurrentUser();
    CollectionReference users = FirebaseFirestore.instance.collection('comments');
    String postId = randomAlphaNumeric(12);
    String username = await _username();

    return users.doc(postId)
        .set({
      'userId': uid,
      'username': username,
      'commentId': postId,
      'comment': commentController.text,
      'time': DateTime.now(),
    }).then((value) => print('comment added'))
        .catchError((error)=> print('failed to add comment: $error'));
  }
}

class CommentsDisplay extends StatefulWidget {
  @override
  _CommentsDisplayState createState() => _CommentsDisplayState();
}

class _CommentsDisplayState extends State<CommentsDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff07239d),
        title: Text('comments'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('comments')
            .orderBy('time', descending: true)
            .snapshots(),
          builder: (context, asyncSnapshot){
            if(asyncSnapshot.hasError){
              return Center(child: Text("Error!"));
            }else if(!asyncSnapshot.hasData){
              return Center(child: CircularProgressIndicator()
              );
            }
              print("DATA CHUNK LENGTH ${asyncSnapshot.data.docs.length}");
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: asyncSnapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index)
                  //children: snapshot.data.docs.map((document)
                  {
                    return Flexible(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10,20, 10, 20),
                        padding: EdgeInsets.fromLTRB(10,20, 10, 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(width: 1.0, color: Colors.grey),
                        ),
                        child: Column(
                          children: [
                            Row(
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(asyncSnapshot.data.docs[index]
                                    .data()["username"]
                                      .toString(),
                                  style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 13,
                                )),
                                Text('${DateFormat().add_MMMEd().add_Hm().format(asyncSnapshot.data.docs[index].data()["time"].toDate())}',
                                    style:TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                )),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:10.0),
                              child: Text(asyncSnapshot.data.docs[index]
                                  .data()["comment"]
                                  .toString(),
                                  textAlign: TextAlign.left,
                                  // overflow: TextOverflow.,
                                  style:TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff07239d),
        child: Icon(
          Icons.add
        ),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CommentPage()));
        },
      ),
    );
  }
}

