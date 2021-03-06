import 'dart:async';
import 'dart:convert';
import 'package:redux/redux.dart';
import 'package:office_fit/redux/Actions.dart';
import 'package:office_fit/redux/AppState.dart';
import 'package:office_fit/util/DataPersistance.dart';
import 'package:office_fit/util/ReminderNotificationUtil.dart';


List<Middleware<AppState>> createStoreMiddleware() => [
  TypedMiddleware<AppState, AddActivity>(_addActivity),
  TypedMiddleware<AppState, EditActivity>(_editActivity),
  TypedMiddleware<AppState, RemoveActivity>(_removeActivity),
  TypedMiddleware<AppState, SelectActivity>(_selectActivity),
  TypedMiddleware<AppState, DoActivity>(_doActivity),
  TypedMiddleware<AppState, UndoActivity>(_undoActivity),
];

_saveState( AppState state ) async {

  DataPersistance dao = await DataPersistance.instance;
  var encoded = json.encode( state );
  dao.save(encoded);

  if( dao.lastNotified == null ){
    dao.lastNotified = DateTime.now();
  }

  //print( "save this encoded model -> " + encoded );
}

Future _addActivity(Store<AppState> store, AddActivity action, NextDispatcher next) async {

  print( "add activity " + action.item.title.title );
  next(action);

  _saveState( store.state );

  ReminderNotificationUtil reminderUtil = new ReminderNotificationUtil();
  reminderUtil.cancelReminder();
  reminderUtil.addReminder( store.state, DateTime.now() );

}

Future _editActivity(Store<AppState> store, EditActivity action, NextDispatcher next) async {

  print( "edit activity " + action.item.title.title );
  next(action);

  _saveState( store.state );

  ReminderNotificationUtil reminderUtil = new ReminderNotificationUtil();
  reminderUtil.cancelReminder();
  reminderUtil.addReminder( store.state, DateTime.now() );
}

Future _removeActivity(Store<AppState> store, RemoveActivity action, NextDispatcher next) async {

  print( "remove activity " + action.item.title.title  );
  next(action);

  _saveState( store.state );

  ReminderNotificationUtil reminderUtil = new ReminderNotificationUtil();
  reminderUtil.cancelReminder();
  reminderUtil.addReminder( store.state, DateTime.now() );

}

Future _selectActivity(Store<AppState> store, SelectActivity action, NextDispatcher next) async {
   print( "select activity " + action.item.title.title  );
   next(action);
}

Future _doActivity(Store<AppState> store, DoActivity action, NextDispatcher next) async {
  print( "do activity " + action.item.title.title + ", " + action.item.perf.today().count.toString() + " times" );
  next(action);
}

Future _undoActivity(Store<AppState> store, UndoActivity action, NextDispatcher next) async {
  print( "undo activity " + action.item.title.title + ", " + action.item.perf.today().count.toString() + " times");
  next(action);
}

