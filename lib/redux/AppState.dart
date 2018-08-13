import 'package:office_fit/models/ActivityViewModel.dart';

class AppState {

  final List<ActivityViewModel> activities;
  final ActivityViewModel currentActivity;

  AppState(this.activities, this.currentActivity);

  factory AppState.initial() => AppState(List.unmodifiable([]), new ActivityViewModel() );

  Map<String, dynamic> toJson(){
    return {
      'activities': this.activities.map ( (_avm) => _avm.toJson() ).toList(),
      'currentActivity': this.currentActivity.toJson(),
    };
  }

  AppState.fromJson(Map<String, dynamic> json)
      : activities =  (json['activities'] as List).map((i) => ActivityViewModel.fromJson(i)).toList(),
        currentActivity = json['currentActivity'] == null ? null : ActivityViewModel.fromJson(json['currentActivity']);

}