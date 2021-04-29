import 'package:flutter/material.dart';
import 'package:ola_energy/widgets/multi_form_reports.dart';

class EmptyState extends StatelessWidget {
  final String title, message;
  EmptyState({this.title, this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 16,
      color: Theme.of(context).cardColor.withOpacity(.95),
      shadowColor: Theme.of(context).accentColor.withOpacity(.5),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Daily Sales", style: Theme.of(context).textTheme.headline3),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Create a form to enter daily sales by tapping the + button'),
            ),
          ],
        ),
      ),
    );
  }
}