import 'package:flutter/material.dart';

class CardProgressIndicator extends StatelessWidget {

  final int timeLeft;
  final int total;

  CardProgressIndicator({ this.timeLeft, this.total });

  @override
  Widget build(BuildContext context) {

    return new Padding(

      padding: new EdgeInsets.only( left: 23.0, right:23.0 ),
      child: new ClipRRect(

        child: new LinearProgressIndicator(
          value: timeLeft / total,
          backgroundColor: Colors.red.withOpacity( 0.2 ),
          valueColor: AlwaysStoppedAnimation<Color>( Colors.red ),
        ),

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical( 5.0 , 5.0 ),
          bottomRight: Radius.elliptical( 5.0 , 5.0 ),
        ),

      ),

    );
  }

}