import 'package:flutter/material.dart';
import 'package:office_fit/widgets/DropdownNew.dart';
import 'package:office_fit/widgets/DropdownNewDur.dart';
import 'package:office_fit/util/TimeListUtil.dart';
import 'package:office_fit/util/NumberTimesListUtil.dart';
import 'package:office_fit/widgets/RedButton.dart';
import 'package:office_fit/models/ActivityViewModel.dart';
import 'package:office_fit/util/DurationUtil.dart';
import 'package:office_fit/AppRoutes.dart';

class AddNewActivityScreen extends StatefulWidget {

  AddNewActivityScreen({ this.viewModel, this.onSubmit });

  final ActivityViewModel viewModel;
  final ValueChanged<ActivityViewModel> onSubmit;

  @override
  _AddNewActivityState createState() => _AddNewActivityState();
}

class _AddNewActivityState extends State<AddNewActivityScreen>{

  bool isAllSelected(){
    return  _viewModel.title != null &&
            _viewModel.repetitions != null &&
            _viewModel.interval != null &&
            _viewModel.when != null &&
            _viewModel.start != null &&
            _viewModel.end != null ;
  }

  ActivityViewModel _viewModel = new ActivityViewModel();

  @override
  Widget build(BuildContext context) {

    return new Scaffold(

      appBar: new AppBar(

        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon( Icons.keyboard_arrow_left, color: Colors.black ),
          onPressed: () => Navigator.pop(context),
        ),

        title: new Text(
          "Add New",
          style: new TextStyle( color: Colors.black, fontSize: 20.0 , fontWeight: FontWeight.w300 ),
        ) ,

        backgroundColor: Theme.of(context).canvasColor.withOpacity( 0.99 ), elevation: 0.0,
      ),

      body: new ListView(
        children: <Widget>[

          new DropdownNew(
            title: "Remind me to:",
            hint: "Select Activity",
            selected:  _viewModel.title.title,
            values: ActivityType.toList(),
            onSelect: (_) => this.setState( () =>  _viewModel.title = ActivityType.find(_) ),
          ),

          new DropdownNew(
            title: "How many times?",
            hint: "Select Time",
            selected:  _viewModel.repetitions == null ? null : _viewModel.repetitions.toString() + " times",
            values: NumberTimesListUtil.getAsList( 30 , "times" ),
            onSelect: (_) => this.setState( () =>  _viewModel.repetitions = int.parse( _.split(" ")[0] ) ),
          ),

          new DropdownNewDur(
            title: "Interval period?",
            hint: "Select Interval",
            selected:  _viewModel.interval,
            values: <String, Duration>{
              '5 mins': new Duration( minutes: 5 ),
              '15 mins': new Duration( minutes: 15 ),
              '30 mins': new Duration( minutes: 30 ),
              '45 mins': new Duration( minutes: 45 ),
              '1 hr': new Duration( hours: 1 ),
              '2 hr': new Duration( hours: 2 ),
              '3 hr': new Duration( hours: 3 ),
            },
            onSelect: (_) => this.setState( () =>  _viewModel.interval = _ ),
          ),

          new DropdownNew(
            title: "When?",
            hint: "Select which days to notify",
            selected:  _viewModel.when,
            values: <String>[
              'Weekdays', 'Mon to Sat', 'Weekends', 'Sunday', 'Saturday'
            ],
            onSelect: (_) => this.setState( () =>  _viewModel.when = _ ),
          ),

          new DropdownNew(
            title: "Start at?",
            hint: "Select when to start",
            selected:  DurationUtil.getAsHHMM( _viewModel.start ),
            values: TimeListUtil.getAsStringList( 30 ),
            onSelect: (_) => this.setState( () =>  _viewModel.start = DurationUtil.getDurationFromHHMM( _ )),
          ),

          new DropdownNew(
            title: "End at?",
            hint: "Select when to end",
            selected: DurationUtil.getAsHHMM( _viewModel.end ),
            values: TimeListUtil.getAsStringList( 30 ),
            onSelect: (_) => this.setState( () =>  _viewModel.end = DurationUtil.getDurationFromHHMM( _ ) ),
          ),

          new RedButton(
            text: "Submit",
            onPressed: ((){
              widget.onSubmit(_viewModel);
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.listActivities, (Route<dynamic> route) => false) ;
            }),
            enabled: isAllSelected(),
          ),


        ],
      ),

    );
  }
}