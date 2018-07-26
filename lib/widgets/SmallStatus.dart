import 'package:flutter/material.dart';


class SmallStatus extends StatelessWidget {

  final IconData icon;
  final String label;
  final String value;

  SmallStatus({ this.icon, this.label, this.value });

  @override
  Widget build(BuildContext context) {
    return  new Expanded(
        child: new Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

            new Padding(
              padding: new EdgeInsets.only( bottom: 5.0 ),
              child: new Icon( this.icon, color: Colors.black.withOpacity( 0.7 ), ),
            ),

            new Text( this.label, style: new TextStyle( fontWeight: FontWeight.bold, color: Colors.black.withOpacity( 0.8 ) ), ),
            new Text( this.value, style: new TextStyle( fontWeight: FontWeight.w400, fontSize: 14.0 ), ),

          ],
        )
    );
  }
}