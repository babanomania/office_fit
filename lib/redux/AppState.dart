import 'package:office_fit/models/ActivityViewModel.dart';

class AppState {

  final List<ActivityViewModel> activities;
  final ActivityViewModel currentActivity;

  AppState(this.activities, this.currentActivity);

  factory AppState.initial() => AppState(List.unmodifiable([]), new ActivityViewModel() );
}