import 'package:intl/intl.dart';
import 'package:office_fit/util/DurationUtil.dart';
import 'package:flutter/foundation.dart';

class ActivityViewModel {

  ActivityViewModel();

  ActivityType title = new ActivityType();//"Drink Water";
  int repetitions; //"10 times";
  Duration interval; //"45 mins";
  String when; //"Weekdays";
  Duration start; //"08:00";
  Duration end; //"18:00";

  ActivityPerformanceModel perf = new ActivityPerformanceModel();

  bool doRemindForDate( DateTime itemWhen ){

    var dtWeekday = itemWhen.weekday;
    bool doRemind = false;

    if( this.when == 'Weekdays' ){
        doRemind = ( dtWeekday != DateTime.saturday && dtWeekday != DateTime.sunday ) ? true : false ;

    } else if( this.when == 'Mon to Sat' ){
        doRemind = dtWeekday != DateTime.sunday ? true : false ;

    } else if( this.when == 'Weekends' ){
        doRemind = ( dtWeekday == DateTime.saturday || dtWeekday == DateTime.sunday ) ? true : false ;

    } else if( this.when == 'Sunday' ){
        doRemind = dtWeekday == DateTime.sunday ? true : false ;

    } else if( this.when == 'Saturday' ){
        doRemind = dtWeekday == DateTime.saturday ? true : false ;
    }

    return doRemind;
  }

  bool isPastTime( DateTime itemWhen ){
    DateTime endOn = DurationUtil.atMidnight( itemWhen ).add( this.end );
    return ( itemWhen.isBefore( endOn ) );
  }

  List<DateTime> getNotificationTimes( DateTime pWhen ){

    List<DateTime> notifications = new List();
    Duration startWith = new Duration( minutes: start.inMinutes );

    while( startWith.inMinutes <= end.inMinutes ){
      notifications.add(
          DurationUtil.atMidnight( pWhen ).add( startWith )
      );

      startWith += interval;
    }

    //debugPrint( "getNotificationTimes - " + notifications.toString() + " for pWhen " + pWhen.toString()  );
    return notifications;
  }

  Duration nextNotification( DateTime pWhen ){

    if( doRemindForDate( pWhen ) ){

      List<DateTime> notifications = getNotificationTimes(pWhen);
      if( notifications.isNotEmpty && pWhen.isAfter( notifications.last ) ){

        debugPrint( "< nextNotification 1 " + " for pWhen " + pWhen.toString()  );
        return nextNotificationOn( pWhen );

      } else if ( notifications.isNotEmpty ){

        debugPrint( "< nextNotification 2 " + " for pWhen " + pWhen.toString()  );
        return notifications
            .firstWhere((_dt) => _dt.isAfter( pWhen ))
            .difference( pWhen );
      }

    } else {

        debugPrint( "< nextNotification 3 " + " for pWhen " + pWhen.toString()  );
        return nextNotificationOn( pWhen );

    }

    return null;
  }

  Duration nextNotificationOn( DateTime pWhen ){

    Duration nextNotificationOn = new Duration( minutes: 0 );

    for( int dat=1; dat<=8; dat++ ){

      DateTime thatDate = pWhen.add( new Duration( days: dat ) );
      bool isEnabled = doRemindForDate( thatDate );

      if( isEnabled ){
        debugPrint( "nextNotificationOn - days " + dat.toString() + " for pWhen " + pWhen.toString() );
        return new Duration( days: dat );
      }

    }

    debugPrint( "nextNotificationOn - " + nextNotificationOn.toString() + " for pWhen " + pWhen.toString() );
    return nextNotificationOn;
  }

  Map<String, dynamic> toJson(){
    return {
      'title': this.title == null ? null : this.title.toJson(),
      'repetitions': this.repetitions,
      'interval': this.interval == null ? null : this.interval.inMinutes,
      'when': this.when,
      'start': this.start == null ? null : this.start.inMinutes,
      'end': this.end == null ? null : this.end.inMinutes,
      'perf': this.perf == null ? null : this.perf.toJson(),
    };
  }

  ActivityViewModel.fromJson(Map<String, dynamic> json)
      : title =  ActivityType.fromJson(json['title']),
        repetitions = json['repetitions'],
        interval = json['interval'] == null ? null : new Duration( minutes : json['interval'] ),
        when = json['when'],
        start = json['start'] == null ? null : new Duration( minutes : json['start'] ),
        end = json['end'] == null ? null : new Duration( minutes : json['end'] ),
        perf = ActivityPerformanceModel.fromJson(json['perf']);
}

class ActivityPerformanceModel {

  ActivityPerformanceModel();

  List<ActivityDayRecord> history = <ActivityDayRecord>[];
  ActivityDayRecord best;
  ActivityDayRecord worst;

  ActivityDayRecord today(){

    ActivityDayRecord today = new ActivityDayRecord( recordDate: DateTime.now(), count: 0 );
    Iterable historySearch = history.where( (_adr) => _adr.recordDate == DurationUtil.atMidnight( DateTime.now() ) );

    if( historySearch.isEmpty || ( historySearch.first == null ) ){
      history.add( today );

    } else {
      today = historySearch.first;

    }

    history.retainWhere( (_adr) =>
                            _adr.recordDate.isAfter(
                                DurationUtil.atMidnight( DateTime.now() )
                                            .subtract( Duration( days: 5 ) )
                            )
                        );
    return today;
  }

  Map<String, dynamic> toJson(){
    return {
      'history': this.history.map( (_adr) => _adr.toJson() ).toList(),
      'best': this.best == null ? null : this.best.toJson(),
      'worst': this.worst == null ? null : this.worst.toJson()
    };
  }

  ActivityPerformanceModel.fromJson(Map<String, dynamic> json)
      : history = (json['history'] as List).map((i) => ActivityDayRecord.fromJson(i)).toList(),
        best = json['best'],
        worst = json['worst'];
}

class ActivityDayRecord {

  ActivityDayRecord({ this.recordDate, this.count });

  final DateTime recordDate;
  int count;

  String get date => new DateFormat( 'yyyy-MMM-dd' ).format( recordDate );
  String get day => new DateFormat( 'E' ).format( recordDate );

  increment() => count++;
  decrement() => count--;

  Map<String, dynamic> toJson(){
    return {
      'recordDate': this.recordDate.toString(),
      'count': this.count,
    };
  }

  ActivityDayRecord.fromJson(Map<String, dynamic> json)
      : recordDate =  DateTime.parse(json['recordDate']),
        count = json['count'];

}

class ActivityType {

  int index;
  String image;
  String title;
  ActivityType({ this.index, this.image, this.title });

  static List<ActivityType> types = <ActivityType>[

    new ActivityType(
        index: 0,
        title: "Drink Water",
        image: 'images/drink_water.png'
    ),

    new ActivityType(
        index: 1,
        title: "Stand Up",
        image: 'images/stand_up.png'
    ),

    new ActivityType(
        index: 2,
        title: "Stretch",
        image: 'images/stretch.png'
    ),

    new ActivityType(
        index: 3,
        title: "Short Walks",
        image: 'images/walk.png'
    ),

  ];

  static ActivityType find( String pType ){
    return types.where( (type) => type.title == pType ).first;
  }

  static List<String> toList(){
    return types.map( (type) => type.title ).toList();
  }

  Map<String, dynamic> toJson(){
    return {
      'index': this.index,
      'title': this.title,
      'image': this.image,
    };
  }

  ActivityType.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        title = json['title'],
        image = json['image'];
}