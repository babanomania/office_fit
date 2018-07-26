import 'package:flutter/material.dart';
import 'package:office_fit/widgets/BarChart.dart';

class HistoryCard extends StatelessWidget {

  final List<BarData> data;
  HistoryCard({ this.data });

  @override
  Widget build(BuildContext context) {
    return new Card(
      elevation: 5.0,
      margin: new EdgeInsets.all( 10.0 ),
      child: new Column(
        children: <Widget>[
          new ListTile(
            leading: new Icon( Icons.history, size: 28.0, color: Colors.black,),
            title: new Text(
              "History",
              style: new TextStyle( fontWeight: FontWeight.bold, fontSize: 18.0 ),
            ),
          ),
          new BarChart(
            data: data,
          ),
        ],
      ),
    );
  }

}