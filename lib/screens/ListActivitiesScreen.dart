import 'package:flutter/material.dart';
import 'package:office_fit/widgets/ActivityStatusCard.dart';
import 'package:office_fit/AppRoutes.dart';

class ListActivitiesScreen extends StatelessWidget {

  ListActivitiesScreen({ this.openDetail, this.deleteActivity });

  final ValueChanged<String> openDetail ;
  final ValueChanged<String> deleteActivity ;

  @override
  Widget build(BuildContext context) {
      
      return new Scaffold(

        appBar: new AppBar(
          automaticallyImplyLeading: false,
          title: new Text( 
            "Office Fitness Assistant",
            style: new TextStyle( color: Colors.black, fontSize: 20.0 , fontWeight: FontWeight.w300 ),
          ) ,
          backgroundColor: Theme.of(context).canvasColor.withOpacity( 0.99 ), elevation: 0.0,
        ),

        body: new ListView(

          children: <Widget>[

            new ActivityStatusCard(

              imageAsset: 'images/drink_water.png',
              title: "Drink Water",

              currentActivityCnt: 4,
              totalActivityCnt: 10,

              nextNotification: new Duration( minutes: 0 ),
              notificationInterval: new Duration( minutes: 45 ),

              openDetail: ((_) {
                openDetail(_);
                Navigator.pushNamed(context, AppRoutes.activityDetail);
              }),
              deleteActivity: deleteActivity,
            ),

            new ActivityStatusCard(
              imageAsset: 'images/stand_up.png',
              title: "Stand Up",

              currentActivityCnt: 5,
              totalActivityCnt: 40,

              nextNotification: new Duration( minutes: 31 ),
              notificationInterval: new Duration( hours: 1 ),

              openDetail: ((_) {
                openDetail(_);
                Navigator.pushNamed(context, AppRoutes.activityDetail);
              }),
              deleteActivity: deleteActivity,
            ),

            new ActivityStatusCard(
              isEnabled: false,

              imageAsset: 'images/stretch.png',
              title: "Stretch",

              currentActivityCnt: 4,
              totalActivityCnt: 20,

              nextNotification: new Duration( hours: 1, minutes: 23 ),
              notificationInterval: new Duration( hours: 2 ),

              openDetail: ((_) {
                openDetail(_);
                Navigator.pushNamed(context, AppRoutes.activityDetail);
              }),
              deleteActivity: deleteActivity,
            ),

            new ActivityStatusCard(
              imageAsset: 'images/walk.png',
              title: "Short Walks",

              currentActivityCnt: 5,
              totalActivityCnt: 5,

              nextNotification: new Duration( minutes: 0 ),
              notificationInterval: new Duration( minutes: 15 ),

              openDetail: ((_) {
                openDetail(_);
                Navigator.pushNamed(context, AppRoutes.activityDetail);
              }),
              deleteActivity: deleteActivity,
            ),

          ],

        ),

        floatingActionButton: new FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              child: new Icon( Icons.add ),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.addNewActivity),
            ),

      );
    }

}