import 'package:flutter/material.dart';
import 'package:office_fit/widgets/CircularProgress.dart';
import 'package:office_fit/widgets/CardProgressIndicator.dart';
import 'package:office_fit/util/DurationUtil.dart';

class ActivityStatusCard extends StatelessWidget {

  ActivityStatusCard({  this.isEnabled = true, this.imageAsset, this.title,
                        this.currentActivityCnt, this.totalActivityCnt,
                        this.nextNotification, this.notificationInterval ,
                        this.start, this.end,
                        this.openDetail, this.deleteActivity,
                      });

  final bool isEnabled;

  final String imageAsset;
  final String title;

  final int currentActivityCnt;
  final int totalActivityCnt;

  final Duration nextNotification ;
  final Duration notificationInterval ;

  final Duration start;
  final Duration end;

  final VoidCallback openDetail ;
  final VoidCallback deleteActivity ;

  final Color disabled = Colors.grey;

  bool isNotifyNow(){
    return nextNotification.inMinutes == 0 ;
  }

  _getLeadingIcon(context){
    return new Container(
      color: Theme.of(context).canvasColor,
      child: new Image.asset(
        imageAsset,
        height: 40.0,
        color: isEnabled ? Theme.of(context).textTheme.title.color : Theme.of(context).disabledColor,
      ),
    );
  }

  _getTitle(context){
    return new Padding(
        padding: new EdgeInsets.only( bottom: 20.0 ),
        child: new Text(
          this.title,
          style: new TextStyle(
              color: isEnabled ? Colors.black : Theme.of(context).disabledColor,
              fontSize: 20.0
          ),
        )
    );
  }

  _getSubTitle(){
    return new Text(
        isEnabled ?
        currentActivityCnt.toString() + "/" + totalActivityCnt.toString() + " Completed" :
        "Active in " + DurationUtil.getAsText( nextNotification )
    );
  }

  _getTrailingIconText(){

    final allTasksDone = ( currentActivityCnt == totalActivityCnt );

    DateTime startTime = DurationUtil.atMidnight( DateTime.now() ).add( this.start );
    DateTime endTime = DurationUtil.atMidnight( DateTime.now() ).add( this.start );
    bool finishedInPast = endTime.isBefore( DateTime.now() );
    bool startInFuture = startTime.isAfter( DateTime.now() );

    return new Column(
      children: <Widget>[

        new CircularProgress(
          isEnabled: this.isEnabled,
          value: startInFuture ? 0.0 : ( finishedInPast ? 1.0 : nextNotification.inMinutes / notificationInterval.inMinutes ),
          allDone: allTasksDone,
        ),

        new Padding(
          padding: new EdgeInsets.only( top: 5.0, ),
          child: new Text(
            ( allTasksDone || !isEnabled ) ? " " : ( isNotifyNow() ? " now " : DurationUtil.getAsText( nextNotification ) ),
            style: new TextStyle( color: Colors.grey ),
          ),

        ),
      ],
    );

  }

  @override
  Widget build(BuildContext context) {


      return new Dismissible(

          key: new GlobalKey(),
          onDismissed: (_) => deleteActivity(),
          background: new ListTile(
            leading: new Padding(
              padding: new EdgeInsets.only( top: 50.0, left: 30.0 ),
              child: new Icon( Icons.delete ),
            )
          ),
          secondaryBackground: new ListTile(
              trailing: new Padding(
                padding: new EdgeInsets.only( top: 50.0, right: 30.0 ),
                child: new Icon( Icons.delete ),
              )
          ),

          child: new Column(
            children: <Widget>[

              new Card(

                elevation: 4.0,
                margin: EdgeInsets.only( top: 20.0, left: 20.0, right: 20.0 ),
                child: new ListTile(

                  contentPadding: new EdgeInsets.only( top:10.0, bottom: 10.0, left: 15.0, right: 15.0 ),

                  leading: _getLeadingIcon(context),
                  title: _getTitle(context),
                  subtitle: _getSubTitle(),
                  trailing: _getTrailingIconText(),

                  onTap: this.isEnabled ? ((){
                    this.openDetail();
                  }) : null,

                ),

              ),

              isEnabled ?
                new CardProgressIndicator(
                  timeLeft: this.currentActivityCnt,
                  total: this.totalActivityCnt,
                ) :
                new Text( " " ),

            ],
          )

      );
  }

}