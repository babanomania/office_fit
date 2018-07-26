import 'package:flutter/material.dart';
import 'package:office_fit/widgets/RedButton.dart';
import 'package:office_fit/AppRoutes.dart';

class OnBoardScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return new Scaffold(

      appBar: new AppBar(  backgroundColor: Colors.white, elevation: 0.0, ),

      body: new Container(
        
        color: Colors.white,
        child: new Center(

          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset( 'images/onboard.jpg', height: 300.0, ),
              new Text( 
                "Stay fit, while working!",
                style: new TextStyle( color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold ),
              ),
              new Padding(
                padding: new EdgeInsets.only( top: 10.0, left: 50.0, right: 50.0 ),
                child: new Text( 
                  "Simple, yet important reminders to get you moving & stay healthy in your long sedentary office hours",
                  textAlign: TextAlign.center,
                  style: new TextStyle( color: Colors.black45 ),
                ),
              )
              
            ],  
          ),
        ),
      ),

      bottomNavigationBar: new RedButton(
        text: "Let's get started",
        onPressed: () => Navigator.pushNamed(context, AppRoutes.listActivities),
      ),

    );
  }

}