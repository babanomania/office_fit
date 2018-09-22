import 'package:office_fit/models/ActivityViewModel.dart';
import 'package:office_fit/util/DurationUtil.dart';

class ReminderNotificationUtil {

  static addReminders( ActivityViewModel item, DateTime reminderDT ){

    if( item.doRemindForDate( reminderDT ) ){

      ActivityDayRecord record = new ActivityDayRecord( recordDate: DurationUtil.atMidnight( reminderDT ), count: 0 );
      _addNotifications();
      item.perf.history.add( record );

    }

  }

  static _addNotifications( ){
    //show notifications
  }
}