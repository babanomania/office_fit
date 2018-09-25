import 'dart:convert';
import 'dart:async';
import 'package:office_fit/util/DataPersistance.dart';
import 'package:office_fit/redux/AppState.dart';
import 'package:android_job_scheduler/android_job_scheduler.dart';
import 'package:office_fit/models/ActivityViewModel.dart';

class ReminderNotificationUtil {

    static cancelReminder(){
      AndroidJobScheduler.cancelAllJobs();
    }

   static addReminder( AppState state, DateTime lastNotified ){

     Duration nextNotification = new Duration( days: 8 );
     bool foundNext = false;

     state.activities.forEach( (_avm){

       Duration next = _avm.nextNotification( lastNotified );
       print( "next " + next.toString() );

       if( nextNotification == null ){
          nextNotification = next;
          foundNext = true;

       } else if( nextNotification > next ){
          nextNotification = next;
          foundNext = true;
       }

     });

     if( foundNext )
       _addNotification( nextNotification );

    }

   static _addNotification( Duration nextNotification ) async {

     bool serviceSet = await AndroidJobScheduler.scheduleOnce(
             nextNotification,
             0,
             wakeUpAndRemind,
             persistentAcrossReboots: true,
     );

     if(serviceSet)   print( "service started" );
     else             print( "could not start service" );

    return nextNotification;

    }

    static wakeUpAndRemind() async {

      Future<DataPersistance> future = DataPersistance.instance;
      future.then( (dao) {

        AppState _state = AppState.fromJson( json.decode( dao.retreive() ) );
        DateTime lastNotified = dao.lastNotified;

        ActivityType remindThis = null;
        Duration nextNotification = new Duration( days: 8 );
        bool foundNext = false;

        _state.activities.forEach( (_avm){

          Duration next = _avm.nextNotification( lastNotified );
          if( nextNotification == null ){
            nextNotification = next;
            remindThis = _avm.title;
            foundNext = true;

          } else if( nextNotification > next ){
            nextNotification = next;
            remindThis = _avm.title;
            foundNext = true;
          }

        });
i
        if( foundNext ) {

          final DateTime now = new DateTime.now();
          print("[$now] reminder to " + remindThis.title);

          _addNotification( nextNotification );
        }

        dao.lastNotified = DateTime.now();

      });
    }
}