import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ola_energy/screens/newsDetails.dart';
import 'package:ola_energy/screens/station.dart';
import 'package:ola_energy/widgets/listItem.dart';
import 'package:lipsum/lipsum.dart' as lipsum;
import 'package:ola_energy/widgets/listWidget.dart';
import 'package:ola_energy/widgets/visionCards.dart';
import 'package:web_scraper/web_scraper.dart';

import 'login.dart';

User currentUser;
User photoUrl;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  WebScraper webScraper;
  bool loaded = false;
  String homeDetails;


  @override
  void initState() {
    super.initState();
    _homeDetails();
  }

  _homeDetails() async {
    webScraper = WebScraper('https://olaenergy.com/corporate-profile/corporate/about-us/');
    if(await webScraper.loadWebPage('/')){
    List<Map<String, dynamic>> results =
    webScraper.getElement('div.row.ld-row',
    ['title']);
    setState(() {
    loaded = true;
    homeDetails = results[0]['title'];
    });
    }
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  signOut()async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
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
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
              }
            )
    ],
        ),
        body: ListView(
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
                        SizedBox(height: 10.0,),
                        Text(
                          'History',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          children: [
                            Text('1993',
                              style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10.0,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('START OF INVESTMENTS IN AFRICA',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Tamoil starts downstream business in Egypt as a part of Oilinvest, a European based holding',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          children: [
                            Text('2000 ',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('DECISION TO HAVE A FOOTPRINT IN AFRICA ',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Incorporation of Tamoil Chad S.A., Tamoil Niger S.A., Tamoil Mali S.A. and Tamoil Burkina S.A. Acquisition of Shell Eritrea. '
                                      'Incorporation of Tamoil Africa Holdings Limited in Malta to encompass all Oilinvest activities in Africa',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          children: [
                            Text('2008 ',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8.0,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('EXPANSION THROUGH ACQUISITION',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Acquisition of 5 Shell affiliates in Niger, Chad, Djibouti, Ethiopia and Sudan. '
                                      'Acquisition of 9 ExxonMobil affiliates in Niger, Senegal, Cote d’Ivoire, Gabon, Cameroon, Kenya, Reunion, Tunisia and Morocco'
                                      'Incorporation of Libya Oil Holdings Ltd',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('NOW ',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5.0,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('OTHER ACTIVITIES',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('Acquisition of Joint Oil and Altube. '
                                        'Shareholding in Circle Oil, AIC',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

