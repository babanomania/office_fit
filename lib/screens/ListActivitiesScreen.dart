import 'package:flutter/material.dart';
import 'package:office_fit/widgets/ActivityStatusCard.dart';
import 'package:office_fit/AppRoutes.dart';
import 'package:office_fit/models/ActivityViewModel.dart';
import 'package:office_fit/util/DurationUtil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListActivitiesScreen extends StatelessWidget {

  ListActivitiesScreen({ this.viewModel, this.openDetail, this.deleteActivity });

  final List<ActivityViewModel> viewModel;
  final ValueChanged<ActivityViewModel> openDetail ;
  final ValueChanged<ActivityViewModel> deleteActivity ;

  Widget getListView( BuildContext context ){

    return new ListView(

      children: viewModel.map(
            (ActivityViewModel model) =>

                new ActivityStatusCard(

                  isEnabled: model.perf.history.last != null &&
                             model.perf.history.last.recordDate == DurationUtil.atMidnight( DateTime.now() ),

                  imageAsset: model.title.image,
                  title: model.title.title,

                  currentActivityCnt: model.perf.history.last.count,
                  totalActivityCnt: model.repetitions,

                  nextNotification: model.perf.history.last.nextNotification,
                  notificationInterval: model.interval,

                  openDetail: (() {
                    openDetail( model);
                    Navigator.pushNamed(context, AppRoutes.activityDetail);
                  }),
                  deleteActivity: () => deleteActivity( model ),
                ),

      ).toList(),

    );
  }

  Widget getEmptyText(){
    return new Container(
      child: new Center(
        child: new Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            new Icon( FontAwesomeIcons.handHoldingHeart, color: Colors.grey.withOpacity( 0.2 ), size: 96.0, ),
            new Padding(
                padding: EdgeInsets.all( 10.0 ),
                child: new Text(
                  "Add an activity",
                  style: TextStyle( color: Colors.grey.withOpacity( 0.5 ), fontSize: 24.0 ),
                ),
            ),
          ],

        ),
      ),
    );

  }

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

        body: viewModel.length > 0 ? getListView(context) : getEmptyText(),

        floatingActionButton: new FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              child: new Icon( Icons.add ),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.addNewActivity),
            ),

      );
    }

}