import 'package:flutter/material.dart';

class RedButton extends StatelessWidget {

  RedButton({ this.onPressed, this.text, this.enabled = true });

  final String text;
  final VoidCallback onPressed;
  final enabled;

  @override
  Widget build(BuildContext context) {

    return new Padding(
        padding: new EdgeInsets.only( left: 50.0, right: 50.0, bottom: 30.0, top: 20.0 ),
        child: new RaisedButton(
            color: Colors.red,
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
            child: new Padding(
              padding: new EdgeInsets.only( top: 20.0, bottom: 20.0 ),
              child: new Text( this.text, style: new TextStyle( color: Colors.white, fontSize: 16.0 ), ),
            ),
            onPressed: enabled ? this.onPressed : null,
          ),
      );
  }

}