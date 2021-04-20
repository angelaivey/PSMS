import 'package:flutter/material.dart';
import 'package:ola_energy/widgets/stationsList.dart';

class Stations {
  final stationName;

  Stations(this.stationName);
}

class StationsList extends StatefulWidget {
  @override
  _StationsListState createState() => _StationsListState();
}

class _StationsListState extends State<StationsList> {
  List stations = [
    Stations(
        'Voi'
    ),
    Stations(
        'Muthaiga'
    ),
    Stations(
        'Sotik'
    ),
    Stations(
        'Nakuru'
    ),
    Stations(
        'Narok'
    ),
    Stations(
        'Sabaki'
    ),
    Stations(
        'Ngong'
    ),
    Stations(
        'Mai Mahiu'
    ),
    Stations(
        'Bellevue'
    ),
    Stations(
        'Karen'
    ),
    Stations(
        'Westlands'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stations'),
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
              icon: Icon(Icons.search),
              onPressed: (){
                showSearch(context: context, delegate: StationSearch());
              }
          ),
        ],
      ),
      body: ListView.builder(
          itemBuilder: (context, index){
            return InkWell(
              //direct the selected stations to report generation
              onTap: (){},
              child: Column(
                //use JSON to fetch the station names (Programming addict)
                  children: stations.map((e) => Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(e.stationName,
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                  )).toList()
              ),
            );
          },
          itemCount: stations.length,
      ),
    );
  }
}

class StationSearch extends SearchDelegate<String>{
  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for appbar
    return[
      IconButton(icon: Icon(Icons.clear), onPressed: (){})
    ];
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading action on the left of the appbar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){
          Navigator.pop(context);
        }
    );
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    //show results based on the selection
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // final stations = stationNames();
    // //show when someone searches for something
    // return ListView.builder(
    //     itemBuilder: (context, index){
    //       //final Stations stationsList = stationsList[index];
    //       return ListTile(
    //        title: Text(stations.toString()),
    //       );
    //     },
    //     itemCount: stations.length,
    //     );
    throw UnimplementedError();
  }

}