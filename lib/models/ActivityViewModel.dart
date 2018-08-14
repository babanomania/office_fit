import 'package:intl/intl.dart';

class ActivityViewModel {

  ActivityViewModel();

  ActivityType title = new ActivityType();//"Drink Water";
  int repetitions; //"10 times";
  Duration interval; //"45 mins";
  String when; //"Weekdays";
  Duration start; //"08:00";
  Duration end; //"18:00";

  ActivityPerformanceModel perf = new ActivityPerformanceModel();


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

  Map<String, dynamic> toJson(){
    return {
      'history': this.history.map( (_adr) => _adr.toJson() ).toList(),
      'best': this.best == null ? null : this.best.toJson(),
      'worst': this.worst == null ? null : this.worst.toJson(),
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

  List<DateTime> notifications = [];

  bool get isPastToday => ( notifications == null || notifications.isEmpty || notifications.last.isBefore( DateTime.now() ));

  Duration get nextNotification => isPastToday ? new Duration( minutes: 0 ) :
                                        notifications
                                          .firstWhere( (_dt) => _dt.isAfter( DateTime.now() ) )
                                          .difference( DateTime.now() );

  String get date => new DateFormat( 'yyyy-MMM-dd' ).format( recordDate );
  String get day => new DateFormat( 'E' ).format( recordDate );

  increment() => count++;
  decrement() => count--;

  Map<String, dynamic> toJson(){
    return {
      'recordDate': this.recordDate.toString(),
      'count': this.count,
      'notifications': this.notifications.map ( (_dt) => _dt.toString() ).toList(),
    };
  }

  ActivityDayRecord.fromJson(Map<String, dynamic> json)
      : recordDate =  DateTime.parse(json['recordDate']),
        count = json['count'],
        notifications = (json['notifications'] as List).map((i) => DateTime.parse(i)).toList();

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