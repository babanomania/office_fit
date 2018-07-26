import 'package:flutter/material.dart';

class ActivityFeatCard extends StatelessWidget {

  final String assetName;
  final String title;
  final String date;
  final int count;

  ActivityFeatCard({ this.assetName, this.title, this.date, this.count });

  @override
  Widget build(BuildContext context) {

    return new Card(
      elevation: 5.0,
      margin: new EdgeInsets.all( 10.0 ),
      child: new ListTile(
        leading: new Image.asset( assetName, height: 35.0, ),
        title: new Text(
          title,
          style: new TextStyle( fontWeight: FontWeight.bold ),
        ),
        subtitle: new Text( date ),
        trailing: new Text(
          count.toString(),
          style: new TextStyle( fontSize: 20.0 ),
        ),
      ),
    );
  }

}