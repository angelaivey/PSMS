import 'package:flutter/material.dart';
import 'listItem.dart';

Widget listWidget(ListItem item){
  return Card(
    elevation: 2.0,
    margin: EdgeInsets.only(bottom: 12.0),
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: '${item.newsTile}',
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(item.imgUrl),
                  fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget> [
                  Text(
                    item.newsTile,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Icon(Icons.person),
                      Text(
                        item.reporter,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Icon(Icons.date_range),
                      Text(
                        item.date,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ),
        ],
      ),
    ),
  );
}