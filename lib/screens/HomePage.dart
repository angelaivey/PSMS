import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ola_energy/screens/newsDetails.dart';
import 'package:ola_energy/widgets/listItem.dart';
import 'package:lipsum/lipsum.dart' as lipsum;
import 'package:ola_energy/widgets/listWidget.dart';
import 'package:ola_energy/widgets/visionCards.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  //make the list
  List<ListItem> listTiles = [
    ListItem(
      'assets/images/newsfeed/burning.jpg',
      lipsum.createWord(numWords: 6),
      lipsum.createWord(numWords: 2),
      '2 Feb 2021',
    ),
    ListItem(
      'assets/images/newsfeed/delta.jpg',
      lipsum.createWord(numWords: 6),
      lipsum.createWord(numWords: 2),
      '2 Feb 2021',
    ),
    ListItem(
      'assets/images/newsfeed/plan.jpg',
      lipsum.createWord(numWords: 6),
      lipsum.createWord(numWords: 2),
      '2 Feb 2021',
    ),
    ListItem(
      'assets/images/newsfeed/pumping.jpg',
      lipsum.createWord(numWords: 6),
      lipsum.createWord(numWords: 2),
      '2 Feb 2021',
    ),
    ListItem(
      'assets/images/newsfeed/shell1.jpg',
      lipsum.createWord(numWords: 6),
      lipsum.createWord(numWords: 2),
      '2 Feb 2021',
    ),
    ListItem(
      'assets/images/newsfeed/stockpic.jpg',
      lipsum.createWord(numWords: 6),
      lipsum.createWord(numWords: 2),
      '2 Feb 2021',
    ),
    ListItem(
      'assets/images/newsfeed/shortage.jpg',
      lipsum.createWord(numWords: 6),
      lipsum.createWord(numWords: 2),
      '2 Feb 2021',
    ),
    ListItem(
      'assets/images/newsfeed/shopping.jpg',
      lipsum.createWord(numWords: 6),
      lipsum.createWord(numWords: 2),
      '2 Feb 2021',
    ),
  ];

  List<Tab> _tabList = [
    Tab(
      child: Text('Home'),
    ),
    Tab(
      child: Text('News'),
    ),
  ];

  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Home Page'),
            backgroundColor: Color(0xff07239d),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            bottom: TabBar(
              indicatorColor: Color(0xff07239d),
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.home),
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.newspaper),
                ),
              ],
            ),
          ),
          body: TabBarView(
            //controller: _tabController,
            children: [
              ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            'About us',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'OLA Energy’s core values are firmly rooted in Africa. Our presence in 17 African countries makes us a prominent member of the communities where we operate, contributing to their economic and social development, and therefore to that of the continent as a whole. Loyal to our African origins, OLA Energy strives to be a responsible African Group, operating in accordance with key African ethical values; integrity; honesty and equity.'
                            'Over the years, OLA Energy became a major player in Africa employing over 1,500 diverse employees, generating an estimate of 20,000 indirect jobs in the countries of operations and visited by up to 250,000 customers per day. With over 1,200 service stations, 8 blending plants over 60 fuel terminals and presence in over 50 Airports across Africa, we are proud to maintain and to expand our reach in the African Continent.',
                            style: TextStyle(
                              fontSize: 17.0,
                            ),
                          ),
                          SizedBox(height: 10.0,),
                            SafeArea(
                              child: Column(
                                children: [
                                  VisionCard(),
                                  SizedBox(height: 10.0),
                                  MissionCard(),
                                  SizedBox(height: 10.0),
                                  ValuesCard(),
                                ],
                              ),

                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Upload(),
            ],
          ),
        ),
      ),
    );
  }
}

