import 'package:flutter/material.dart';
import 'package:office_fit/widgets/ActivityFeatCard.dart';
import 'package:office_fit/widgets/BarChart.dart';
import 'package:office_fit/widgets/HistoryCard.dart';
import 'package:office_fit/widgets/SmallStatus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:office_fit/util/DurationUtil.dart';
import 'package:office_fit/models/ActivityViewModel.dart';

enum AppBarMenu { edit, delete }

class ActivityDetailScreen extends StatelessWidget {

  ActivityDetailScreen({ this.editActivity, this.deleteActivity });

  final ValueChanged<String> editActivity;
  final ValueChanged<String> deleteActivity;

  @override
  Widget build(BuildContext context) {


    /**
     * Fake Data Starts
     */
    ActivityViewModel _viewModel = new ActivityViewModel();
    _viewModel.title = new ActivityType( title: "Drink Water", image: null );
    _viewModel.repetitions = 12;
    _viewModel.start = new Duration( hours: 9, minutes: 30 );
    _viewModel.end = new Duration( hours: 19, minutes: 30 );
    _viewModel.interval = new Duration( minutes: 45 );
    _viewModel.when = "Weekdays";
    _viewModel.perf.history = <ActivityDayRecord>[
      new ActivityDayRecord(  recordDate: DateTime.now().subtract( new Duration( days: 5 ) ), count: 20 ),
      new ActivityDayRecord(  recordDate: DateTime.now().subtract( new Duration( days: 4 ) ), count: 17 ),
      new ActivityDayRecord(  recordDate: DateTime.now().subtract( new Duration( days: 3 ) ), count: 15 ),
      new ActivityDayRecord(  recordDate: DateTime.now().subtract( new Duration( days: 2 ) ), count: 18 ),
      new ActivityDayRecord(  recordDate: DateTime.now().subtract( new Duration( days: 1 ) ), count: 10 ),
      new ActivityDayRecord(  recordDate: DateTime.now(), count: 4  )
    ];

    _viewModel.perf.best = new ActivityDayRecord(
        recordDate: new DateTime( 2017, 8, 24 ),
        count: 12
    );

    _viewModel.perf.worst = new ActivityDayRecord(
        recordDate: new DateTime( 2017, 8, 12 ),
        count: 12
    );
    /**
     * Fake Data Ends
     */

    ActivityDayRecord today = _viewModel.perf.history.last;
    ActivityDayRecord bestPerformance = _viewModel.perf.best;
    ActivityDayRecord worstPerformance = _viewModel.perf.worst;

    int historyLengthDisp = _viewModel.perf.history.length - 1;
    final data = _viewModel.perf.history.sublist(0, historyLengthDisp).reversed.map(
        (record) => new BarData( label: record.day, value: record.count )

    ).toList();

    return new Scaffold(

      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon( Icons.keyboard_arrow_left, color: Colors.black ),
          onPressed: () => Navigator.pop(context),
        ),
        title: new Text(
            "Activity Detail",
            style: new TextStyle( color: Colors.black, fontSize: 20.0 , fontWeight: FontWeight.w300 ),
        ),
        iconTheme: Theme.of(context).iconTheme,
        actions: <Widget>[
          new PopupMenuButton<AppBarMenu>(

            onSelected: (AppBarMenu result) {

              if( result == AppBarMenu.edit ) {
                  this.editActivity( _viewModel.title.title );

              } else if( result == AppBarMenu.delete ) {
                  this.deleteActivity( _viewModel.title.title );

              }
            },

            itemBuilder: (BuildContext context) => <PopupMenuEntry<AppBarMenu>>[

              const PopupMenuItem<AppBarMenu>(
                value: AppBarMenu.edit,
                child: const Text('Edit'),
              ),

              const PopupMenuItem<AppBarMenu>(
                value: AppBarMenu.delete,
                child: const Text('Delete'),
              ),

            ],
          )
        ],
        backgroundColor: Theme.of(context).canvasColor.withOpacity( 0.99 ), elevation: 0.0,
      ),


      body: new ListView(

        children: <Widget>[

          new ListTile(

            contentPadding: new EdgeInsets.fromLTRB( 20.0, 0.0, 20.0, 20.0 ),
            title: new Padding(
              padding: new EdgeInsets.only( bottom: 30.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Text(
                        _viewModel.title.title,
                        style: new TextStyle( color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.w900 ),
                      ),
                      new Padding(
                        padding: new EdgeInsets.only( left: 3.0 ),
                        child: new Text(
                          _viewModel.repetitions.toString() + " Times",
                          style: new TextStyle( color: Colors.grey, fontSize: 28.0, fontWeight: FontWeight.w300 ),
                        ),
                      ),
                    ],
                  ),
                  new Text(
                    today.count.toString() + " Completed",
                    style: new TextStyle( color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.normal ),
                  )
                ],
              ),
            ),

            trailing:  new Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,

              children: <Widget>[

                new IconButton(
                  iconSize: 45.0,
                  icon: new CircleAvatar(
                    child: new Icon( FontAwesomeIcons.plus ),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => {},
                ),

                new IconButton(
                  iconSize: 45.0,
                  splashColor: Colors.grey,
                  icon: new CircleAvatar(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.grey,
                    radius: 22.0,
                    child: new Icon( FontAwesomeIcons.undo ),
                  ),
                  onPressed: () => {},
                )

              ],
            ),
          ),

          new ListTile(

            title: new Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                new SmallStatus(
                  icon: FontAwesomeIcons.calendarPlus,
                  label: "Start",
                  value:  DurationUtil.getAsHHMM(_viewModel.start),
                ),

                new SmallStatus(
                  icon: FontAwesomeIcons.calendarMinus,
                  label: "End",
                  value: DurationUtil.getAsHHMM(_viewModel.end),
                ),

                new SmallStatus(
                  icon: FontAwesomeIcons.retweet,
                  label: "Repeat",
                  value: DurationUtil.getAsSimpleText( _viewModel.interval ),
                ),

                new SmallStatus(
                  icon: FontAwesomeIcons.bell,
                  label: "Remind",
                  value: _viewModel.when,
                ),

              ],
            ),

          ),
          
          new HistoryCard(
            data: data,
          ),

          bestPerformance == null ? new Text( " ") :
            new ActivityFeatCard(
              assetName: "images/efficient.png",
              title: "Most Efficient",
              date: bestPerformance.date,
              count: bestPerformance.count
            ),

          worstPerformance == null ? new Text( " ") :
            new ActivityFeatCard(
                assetName: "images/procrastination.png",
                title: "Very Procastinating",
                date: worstPerformance.date,
                count: worstPerformance.count
            ),

        ],
      ),

    );
  }

}