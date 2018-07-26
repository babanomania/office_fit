import 'package:flutter/material.dart';

class BarData {

  String label;
  int value;

  BarData({ this.label, this.value });
}

class BarChart extends StatelessWidget {

  final List<BarData> data;

  BarChart({ this.data });

  Widget getBarLine( String label, int value, int max ){

    return new ListTile(
      dense: true,
      enabled: false,
      leading: new Text( label, style: new TextStyle( fontWeight:  FontWeight.bold ), ),
      title: new LinearProgressIndicator(
          value: value / max,
          backgroundColor: Colors.white,
        ),
      trailing: new Text( value.toString() ),
    );
  }

  @override
  Widget build(BuildContext context) {

    int maxValue = -1;

    data.forEach( (barData){
      maxValue =  maxValue > barData.value ? maxValue : barData.value ;
    });

    return new Padding(
      padding: new EdgeInsets.all( 10.0 ),
      child: new Column(
        children: data.map(  (barData) => getBarLine( barData.label, barData.value, maxValue) ).toList(),
      ),
    );
  }
}