import 'package:intl/intl.dart';

class ActivityViewModel {

  ActivityType title = new ActivityType();//"Drink Water";
  int repetitions; //"10 times";
  Duration interval; //"45 mins";
  String when; //"Weekdays";
  Duration start; //"08:00";
  Duration end; //"18:00";

  ActivityPerformanceModel perf = new ActivityPerformanceModel();
}

class ActivityPerformanceModel {

  List<ActivityDayRecord> history = <ActivityDayRecord>[];
  ActivityDayRecord best;
  ActivityDayRecord worst;

}

class ActivityDayRecord {

  ActivityDayRecord({ this.recordDate, this.count });

  final DateTime recordDate;
  int count;

  List<DateTime> notifications = [];

  Duration get nextNotification => ( notifications == null || notifications.isEmpty ) ? new Duration( minutes: 0 ) :
                                        notifications
                                          .firstWhere( (_dt) => _dt.isAfter( DateTime.now() ) )
                                          .difference( DateTime.now() );

  String get date => new DateFormat( 'yyyy-MMM-dd' ).format( recordDate );
  String get day => new DateFormat( 'E' ).format( recordDate );

  increment() => count++;
  decrement() => count--;

}

class ActivityType {

  String image;
  String title;
  ActivityType({ this.image, this.title });

  static List<ActivityType> types = <ActivityType>[

    new ActivityType(
        title: "Drink Water",
        image: 'images/drink_water.png'
    ),

    new ActivityType(
        title: "Stand Up",
        image: 'images/stand_up.png'
    ),

    new ActivityType(
        title: "Stretch",
        image: 'images/stretch.png'
    ),

    new ActivityType(
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
}