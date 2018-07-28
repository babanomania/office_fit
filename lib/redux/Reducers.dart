import 'package:redux/redux.dart';
import 'package:office_fit/redux/AppState.dart';
import 'package:office_fit/models/ActivityViewModel.dart';
import 'package:office_fit/redux/Actions.dart';

AppState appReducer(AppState state, action) =>
    AppState( listStateReducer(state.activities, action), selectActivityReducer( state.currentActivity, action ) );

final Reducer<List<ActivityViewModel>> listStateReducer = combineReducers([
  TypedReducer<List<ActivityViewModel>, AddActivity>(_addItem),
  TypedReducer<List<ActivityViewModel>, EditActivity>(_editItem),
  TypedReducer<List<ActivityViewModel>, RemoveActivity>(_removeItem),
]);

final Reducer<ActivityViewModel> selectActivityReducer = combineReducers([
  TypedReducer<ActivityViewModel, SelectActivity>(_selectActivity),
  TypedReducer<ActivityViewModel, DoActivity>(_doActivity),
  TypedReducer<ActivityViewModel, UndoActivity>(_undoActivity),
]);

List<ActivityViewModel> _addItem(List<ActivityViewModel> activities, AddActivity action) =>
    List.unmodifiable(List.from(activities)..add(action.item));

List<ActivityViewModel> _editItem(List<ActivityViewModel> activities, EditActivity action) =>
    activities.map( (item) => item.title.title == action.item.title.title ? action.item : item ).toList();

List<ActivityViewModel> _removeItem(List<ActivityViewModel> activities, RemoveActivity action) =>
    List.unmodifiable(List.from(activities)..remove(action.item));

ActivityViewModel _selectActivity(ActivityViewModel currentActivity, SelectActivity action) => action.item;

ActivityViewModel _doActivity(ActivityViewModel currentActivity, DoActivity action){
  if( action.item.perf.history.last.count < action.item.repetitions ){
    action.item.perf.history.last.increment();
  }

  return action.item;
}

ActivityViewModel _undoActivity(ActivityViewModel currentActivity, UndoActivity action){
    if( action.item.perf.history.last.count >= 1 ){
      action.item.perf.history.last.decrement();
    }

    return action.item;
}


