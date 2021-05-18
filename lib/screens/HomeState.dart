import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ola_energy/screens/AnalyticsPage.dart';
import 'package:ola_energy/screens/EditProfile.dart';
import 'package:ola_energy/screens/HomePage.dart';
import 'package:ola_energy/screens/MarketPrices.dart';
import 'package:ola_energy/screens/login.dart';
import 'package:ola_energy/screens/reportGeneration.dart';
import 'package:ola_energy/widgets/multi_form_reports.dart';
import 'package:ola_energy/widgets/posts.dart';

class HomeState extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;

  HomeState({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
  });
  @override
  _HomeStateState createState() => _HomeStateState(
    postId: this.postId,
    ownerId: this.ownerId,
    username: this.username,
    location: this.location,
    description: this.description,
    mediaUrl: this.mediaUrl,
    likes: this.likes,
  );

}

class _HomeStateState extends State<HomeState> {

  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  int likeCount;
  Map likes;

  _HomeStateState({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    this.likeCount,
  });

  int currentIndex = 0;
  final List<Widget> children = <Widget>[
    HomePage(),
    MarketPrices(),
    Post(),
    MultiForm(),
    AnalyticsPage(),
    EditProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: children.elementAt(currentIndex),
      ),

      bottomNavigationBar: BottomNavigationBar(
      currentIndex: 0,
        backgroundColor: Colors.blue,
        onTap: onTabTapped, // this will be set when a new tab is tapped

      items: const<BottomNavigationBarItem> [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          backgroundColor: Color(0xffffac69),
          label: 'Home',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            label: 'Market Prices'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.update_outlined),
          label: 'Updates',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.file_copy_outlined),
            label: 'Generate Reports',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Analysis'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            label: 'Profile'
        ),
      ],
    ),
    );
  }
  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:ola_energy/screens/AnalyticsPage.dart';
// import 'package:ola_energy/screens/EditProfile.dart';
// import 'package:ola_energy/screens/HomePage.dart';
// import 'package:ola_energy/screens/MarketPrices.dart';
// import 'package:ola_energy/widgets/multi_form_reports.dart';
// import 'package:ola_energy/widgets/posts.dart';
//
// class HomeState extends StatefulWidget {
//   @override
//   _HomeStateState createState() => _HomeStateState();
// }
//
// class _HomeStateState extends State<HomeState> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//           length: 6,
//           child: Scaffold(
//               appBar: TabBar(
//                 labelColor: Colors.blue,
//                 unselectedLabelColor: Colors.blue,
//                 tabs: [
//                   Tab(icon: Icon(Icons.home_outlined)),
//                   Tab(icon: Icon(Icons.monetization_on_outlined)),
//                   Tab(icon: Icon(Icons.update_outlined)),
//                   Tab(icon: Icon(Icons.file_copy_outlined)),
//                   Tab(icon: Icon(Icons.analytics_outlined)),
//                   Tab(icon: Icon(Icons.person_outline_outlined)),
//                 ],
//               ),
//             body: TabBarView(
//               children: [
//                 HomePage(),
//                 MarketPrices(),
//                 Post(),
//                 MultiForm(),
//                 AnalyticsPage(),
//                 EditProfile(),
//           ],
//             ),
//           ),
//         );
//   }
// }
