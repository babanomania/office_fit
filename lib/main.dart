import 'package:flutter/material.dart';
import 'package:office_fit/screens/OnBoardScreen.dart';
import 'package:office_fit/screens/ListActivitiesScreen.dart';
import 'package:office_fit/screens/ActivityDetailScreen.dart';
import 'package:office_fit/screens/AddNewActivityScreen.dart';
import 'package:office_fit/AppRoutes.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(

      title: 'Office Fit Demo',

      theme: new ThemeData(
          canvasColor: Colors.white,
          iconTheme: new IconThemeData(
            color: Colors.black,
          ),
      ),

      initialRoute: AppRoutes.listActivities,

      routes: {

        AppRoutes.onBoading: (context) =>
            new OnBoardScreen(),

        AppRoutes.listActivities: (context) =>
            new ListActivitiesScreen(
              openDetail: (_) => print( "detail - " + _ ),
              deleteActivity:  (_) => print( "delete - " + _ ),
            ),

        AppRoutes.activityDetail: (context) =>
            new ActivityDetailScreen(
              editActivity: (_) => print( "edit - " + _ ),
              deleteActivity: (_) => print( "delete - " + _ ),
            ),

        AppRoutes.addNewActivity : (context) =>
            new AddNewActivityScreen(
              onSubmit: (_) => print( "submit - " ),
            ),

      },

    );
  }
}
