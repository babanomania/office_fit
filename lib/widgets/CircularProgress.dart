import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CircularProgress extends StatelessWidget {

  CircularProgress({ this.isEnabled, this.value, this.allDone });

  final bool isEnabled;

  final bool allDone;
  final double value;

  final Icon iconFull = new Icon( FontAwesomeIcons.check );
  final Icon iconPending = new Icon( FontAwesomeIcons.bell );
  
  final Color lightGrey = Colors.grey.withAlpha( 70 );
  final Color darkGrey = Colors.grey.withAlpha( 120 );
  final Color indFull = Colors.blue;

  final EdgeInsetsGeometry paddingCircleInd = new EdgeInsets.only( top: 2.0, left: 2.0 );
  final double fullCircleInd = 1.0;

  Widget timerPendingNow(){

    return new Icon( FontAwesomeIcons.bell, color: Colors.red, );
  }

  Widget disabledIcon(){

    return new Stack(
      children: <Widget>[

        new CircleAvatar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          child: iconPending,
        ),

        new Padding(
          padding: paddingCircleInd,
          child: new CircularProgressIndicator(
            value: fullCircleInd,
            valueColor: AlwaysStoppedAnimation<Color>( lightGrey ),
          ),
        ),

      ],
    );

  }

  Widget timerPendingIcon(){

    return new Stack(
      children: <Widget>[

        new CircleAvatar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          child: iconPending,
        ),

        new Padding(
          padding: paddingCircleInd,
          child: new CircularProgressIndicator(
            value: fullCircleInd,
            valueColor: AlwaysStoppedAnimation<Color>( lightGrey ),
          ),
        ),

        new Padding(
          padding: paddingCircleInd,
          child: new CircularProgressIndicator(
            value: this.value,
            valueColor: AlwaysStoppedAnimation<Color>( indFull ),
          ),
        ),
      ],
    );

  }

  Widget allTasksDone(){

    return new Stack(
      children: <Widget>[

        new CircleAvatar(
          backgroundColor: Colors.white,
          foregroundColor: indFull,
          child: iconFull ,
        ),

        new Padding(
          padding: paddingCircleInd,
          child: new CircularProgressIndicator(
            value: 1.0,
            valueColor: AlwaysStoppedAnimation<Color>( indFull ),
          ),
        ),
      ],
    );

  }

  @override
    Widget build(BuildContext context) {
      
      return  this.isEnabled ? (this.allDone ?
                allTasksDone() :
                (
                    this.value == 0 ?
                      timerPendingNow() :
                      timerPendingIcon()
                ) ) :
      disabledIcon();
    }
}