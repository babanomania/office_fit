import 'dart:async';
import 'package:redux/redux.dart';
import 'package:office_fit/redux/Actions.dart';
import 'package:office_fit/redux/AppState.dart';
import 'package:office_fit/models/ActivityViewModel.dart';
import 'package:office_fit/util/DurationUtil.dart';
import 'dart:convert';
import 'package:office_fit/util/DataPersistance.dart';

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
  //print( "save this encoded model -> " + encoded );
}

 _addNotifications( List<DateTime> notifications, DateTime when, Duration start, Duration end, Duration interval ){

  Duration startWith = new Duration( minutes: start.inMinutes );
  while( startWith.inMinutes <= end.inMinutes ){
    notifications.add(
        DurationUtil.atMidnight( when ).add( startWith )
    );

    startWith += interval;
  }
}

Future _addActivity(Store<AppState> store, AddActivity action, NextDispatcher next) async {
  print( "add activity " + action.item.title.title );

  ActivityDayRecord firstRecord = new ActivityDayRecord( recordDate: DurationUtil.atMidnight( DateTime.now() ), count: 0 );
  _addNotifications( firstRecord.notifications, DateTime.now(), action.item.start, action.item.end, action.item.interval );
  action.item.perf.history.add( firstRecord );

  _saveState( store.state );
  next(action);
}

Future _editActivity(Store<AppState> store, EditActivity action, NextDispatcher next) async {
  print( "edit activity " + action.item.title.title );

  _saveState( store.state );
  next(action);
}

Future _removeActivity(Store<AppState> store, RemoveActivity action, NextDispatcher next) async {
  print( "remove activity " + action.item.title.title  );

  _saveState( store.state );
  next(action);
}

Future _selectActivity(Store<AppState> store, SelectActivity action, NextDispatcher next) async {
   print( "select activity " + action.item.title.title  );
   next(action);
}

Future _doActivity(Store<AppState> store, DoActivity action, NextDispatcher next) async {
  print( "do activity " + action.item.title.title + ", " + action.item.perf.history.last.count.toString() + " times" );
  next(action);
}

Future _undoActivity(Store<AppState> store, UndoActivity action, NextDispatcher next) async {
  print( "undo activity " + action.item.title.title + ", " + action.item.perf.history.last.count.toString() + " times");
  next(action);
}

