import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:office_fit/util/DataPersistance.dart';
import 'package:office_fit/redux/AppState.dart';
import 'package:android_job_scheduler/android_job_scheduler.dart';
import 'package:office_fit/models/ActivityViewModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ReminderNotificationUtil {

   cancelReminder(){
     AndroidJobScheduler.cancelAllJobs();
     debugPrint( "cancelReminder" );
   }

   addReminder( AppState state, DateTime lastNotified ){

     debugPrint( "+addReminder state - " + state.toJson().toString() );

     Duration nextNotification = null;
     bool foundNext = false;

     state.activities.forEach( (_avm){

       debugPrint( "addReminder _avm " + _avm.toJson().toString() );

       Duration next = _avm.nextNotification( lastNotified );
       debugPrint( "addReminder next " + next.toString() );

       if( nextNotification == null ){
          nextNotification = next;
          foundNext = true;
          debugPrint( "addReminder nextNotification == null, foundNext = true, nextNotification " + nextNotification.toString() );

       } else if( nextNotification > next ){
          nextNotification = next;
          foundNext = true;
          debugPrint( "addReminder nextNotification > next, foundNext = true, nextNotification " + nextNotification.toString() );
       }

     });

     if( foundNext ) {
       debugPrint("addReminder foundNext = true , nextNotification = " + nextNotification.toString());
       _addNotification(nextNotification);
     }

   }

   _addNotification( Duration nextNotification ) async {

     bool serviceSet = false;
     try{

       debugPrint( "scheduling using a method" );
       serviceSet = await AndroidJobScheduler.scheduleOnce(
                       nextNotification,
                       0,
                       wakeUpAndRemind,
                       persistentAcrossReboots: true,
                   );

     } catch ( NoSuchMethodError ){

       debugPrint( "scheduling using a getter" );
       serviceSet = await AndroidJobScheduler.scheduleOnce(
                       nextNotification,
                       0,
                       wakeUpAndRemind2,
                       persistentAcrossReboots: true,
                   );
     }


      if(serviceSet)   debugPrint( "service started" );
      else             debugPrint( "could not start service" );

      return nextNotification;

   }

   get wakeUpAndRemind2 async {
     return wakeUpAndRemind();
   }

   wakeUpAndRemind() async {

      debugPrint( "wakeUpAndRemind - just woke up to remind" );
      Future<DataPersistance> future = DataPersistance.instance;
      future.then( (dao) {

        AppState _state = AppState.fromJson( json.decode( dao.retreive() ) );
        debugPrint( "wakeUpAndRemind - got _state" );

        DateTime lastNotified = dao.lastNotified;
        debugPrint( "wakeUpAndRemind - lastNotified " + lastNotified.toString() );

        ActivityType remindThis = null;
        Duration nextNotification = null;
        bool foundNext = false;

        _state.activities.forEach( (_avm){

          debugPrint( "wakeUpAndRemind _avm " + _avm.toJson().toString() );

          Duration next = _avm.nextNotification( lastNotified );
          debugPrint( "wakeUpAndRemind next " + next.toString() );

          if( nextNotification == null ){
            nextNotification = next;
            remindThis = _avm.title;
            foundNext = true;
            debugPrint( "addReminder nextNotification == null, foundNext = true, remindThis " + remindThis.title.toString() + ", nextNotification " + nextNotification.toString() );

          } else if( nextNotification > next ){
            nextNotification = next;
            remindThis = _avm.title;
            foundNext = true;
            debugPrint( "addReminder nextNotification > next, foundNext = true, remindThis " + remindThis.title.toString() + ", nextNotification " + nextNotification.toString() );
          }

        });

        if( foundNext ) {

          debugPrint("addReminder foundNext, nextNotification = " + nextNotification.toString() + ", remindThis " + remindThis.title.toString() );


          FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

          var initializationSettingsAndroid = new AndroidInitializationSettings('ic_notification');
          var initializationSettingsIOS = new IOSInitializationSettings();
          var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

          flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
          flutterLocalNotificationsPlugin.initialize(initializationSettings, selectNotification: onSelectNotification );

          var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
              'office-fit-id', 'office-fit-reminders', 'fitness reminders',
              importance: Importance.Max, priority: Priority.High);

          var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
          var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

          debugPrint( "addReminder flutterLocalNotificationsPlugin.show" );
          flutterLocalNotificationsPlugin.show( 0, 'Remember To ' + remindThis.title, null , platformChannelSpecifics, payload: 'item id 2');

          _addNotification( nextNotification );
        }

        debugPrint( "addReminder dao.lastNotified " + dao.lastNotified.toString() );
        dao.lastNotified = DateTime.now();

      });
    }

    Future onSelectNotification(String payload) async {
      if (payload != null) {
        debugPrint( "notification clicked " );
      }
    }
}