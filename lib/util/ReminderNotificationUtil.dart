import 'package:office_fit/models/ActivityViewModel.dart';
import 'package:office_fit/util/DurationUtil.dart';
import 'package:office_fit/util/DataPersistance.dart';
import 'package:office_fit/redux/AppState.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

class ReminderNotificationUtil {

  static scheduleFromThisWeekend() {

    DateTime now = DateTime.now();
    DateTime nextMidnight = new DateTime( now.year, now.month, now.day ).add( new Duration( days: 1 ) );
    int daysToSatMidnight = DateTime.saturday - nextMidnight.weekday;
    DateTime nextSatNight = nextMidnight.add( new Duration( days: daysToSatMidnight ) );
    Duration nextScheduleAt = nextSatNight.difference( now );

    AndroidAlarmManager.oneShot( nextScheduleAt,
                                 0,
                                 () => ReminderNotificationUtil.addRemindersFromThisWeek(),
                              );
  }

  static addRemindersFromThisWeek() async {

    DataPersistance persistence = await DataPersistance.instance;
    AppState state = AppState.fromJson( persistence.retreive() );
    for( var eachActivity in state.activities ){
      addRemindersNextWeek( eachActivity );
    }

    persistence.save( state.toJson() );

    AndroidAlarmManager.periodic(
        const Duration( days: 7),
        1,
        ReminderNotificationUtil.addWeeklyReminders()
    );
  }

  static addWeeklyReminders() async {
    DataPersistance persistence = await DataPersistance.instance;
    AppState state = AppState.fromJson( persistence.retreive() );
    for( var eachActivity in state.activities ){
      addRemindersNextWeek( eachActivity );
    }

    persistence.save( state.toJson() );
  }

  static addRemindersNextWeek( ActivityViewModel item ){

    DateTime startDt = DurationUtil.atMidnight( DateTime.now() );
    bool loop = true;

    for( var counter = 1; loop && counter <= 7; counter++ ){
      DateTime dtThen = new DateTime.fromMicrosecondsSinceEpoch( startDt.millisecondsSinceEpoch );
      dtThen.add( new Duration( days: counter ) );

      addRemindersThen( item, dtThen );
      loop = dtThen.weekday < DateTime.saturday ? true : false ;
    }
  }

  static addRemindersThen( ActivityViewModel item, DateTime reminderDT ){

    String itemWhen = item.when;
    var dtWeekday = reminderDT.weekday;
    bool addReminderDT = false;

    if( itemWhen == 'Weekdays' ){
      addReminderDT = ( dtWeekday != DateTime.saturday &&
                        dtWeekday != DateTime.sunday ) ? true : false ;

    } else if( itemWhen == 'Mon to Sat' ){
      addReminderDT = dtWeekday != DateTime.sunday ? true : false ;

    } else if( itemWhen == 'Weekends' ){
      addReminderDT = ( dtWeekday == DateTime.saturday ||
                        dtWeekday == DateTime.sunday ) ? true : false ;

    } else if( itemWhen == 'Sunday' ){
      addReminderDT = dtWeekday == DateTime.sunday ? true : false ;

    } else if( itemWhen == 'Saturday' ){
      addReminderDT = dtWeekday == DateTime.saturday ? true : false ;
    }


    if( addReminderDT ){
      ActivityDayRecord record = new ActivityDayRecord( recordDate: DurationUtil.atMidnight( reminderDT ), count: 0 );
      _addNotifications( record.notifications, reminderDT, item.start, item.end, item.interval );
      item.perf.history.add( record );

    }
  }

  static _addNotifications( List<DateTime> notifications, DateTime when, Duration start, Duration end, Duration interval ){

    Duration startWith = new Duration( minutes: start.inMinutes );
    while( startWith.inMinutes <= end.inMinutes ){
      notifications.add(
          DurationUtil.atMidnight( when ).add( startWith )
      );

      startWith += interval;
    }
  }
}