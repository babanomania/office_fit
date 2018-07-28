import 'dart:async';
import 'package:redux/redux.dart';
import 'package:office_fit/redux/Actions.dart';
import 'package:office_fit/redux/AppState.dart';
import 'package:office_fit/models/ActivityViewModel.dart';
import 'package:office_fit/util/DurationUtil.dart';

List<Middleware<AppState>> createStoreMiddleware() => [
  TypedMiddleware<AppState, AddActivity>(_addActivity),
  TypedMiddleware<AppState, RemoveActivity>(_removeActivity),
  TypedMiddleware<AppState, SelectActivity>(_selectActivity),
];

List<DateTime> _addNotifications( DateTime when, Duration start, Duration end, Duration interval ){
  List<DateTime> notifications = [];

  Duration startWith = new Duration( minutes: start.inMinutes );
  while( startWith.inMinutes <= end.inMinutes ){
    notifications.add(
        DurationUtil.atMidnight( when ).add( interval )
    );

    startWith += interval;
  }

  return notifications;
}

Future _addActivity(Store<AppState> store, AddActivity action, NextDispatcher next) async {
  print( "add activity " + action.item.title.title );

  ActivityDayRecord firstRecord = new ActivityDayRecord( recordDate: DurationUtil.atMidnight( DateTime.now() ), count: 0 );
  firstRecord.notifications = _addNotifications( DateTime.now(), action.item.start, action.item.end, action.item.interval );

  action.item.perf.history.add( firstRecord );
  next(action);
}

Future _removeActivity(Store<AppState> store, RemoveActivity action, NextDispatcher next) async {
  print( "remove activity " + action.item.title.title  );
  next(action);
}

Future _selectActivity(Store<AppState> store, SelectActivity action, NextDispatcher next) async {
  print( "select activity " + action.item.title.title  );
  next(action);
}

