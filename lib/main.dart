import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:office_fit/screens/OnBoardScreen.dart';
import 'package:office_fit/screens/ListActivitiesScreen.dart';
import 'package:office_fit/screens/ActivityDetailScreen.dart';
import 'package:office_fit/screens/AddNewActivityScreen.dart';
import 'package:office_fit/models/ActivityViewModel.dart';
import 'package:office_fit/AppRoutes.dart';
import 'package:office_fit/redux/AppState.dart';
import 'package:office_fit/redux/Reducers.dart';
import 'package:office_fit/redux/Middleware.dart';
import 'package:office_fit/redux/Actions.dart';

import 'package:office_fit/util/DataPersistance.dart';
import 'dart:async';

void main() => runApp(new OfficeFitApp());

class OfficeFitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<DataPersistance>(
        future: DataPersistance.instance,
        builder: (context, snapshot){
          return new MyApp(
              store: Store<AppState>(
                        appReducer,
                        initialState: snapshot.data.retreive() == null ?
                                            AppState.initial() :
                                            AppState.fromJson( snapshot.data.retreive() ),

                        middleware: createStoreMiddleware(),
                      )
          );
        },
    );
  }
}

class MyApp extends StatelessWidget {

  final Store<AppState> store ;
  MyApp({ this.store });

  @override
  Widget build(BuildContext context) {

    return StoreProvider(

        store: this.store,
        child: new MaterialApp(

                title: 'Office Fit Demo',

                theme: new ThemeData(
                    canvasColor: Colors.white,
                    iconTheme: new IconThemeData(
                      color: Colors.black,
                    ),
                ),

                initialRoute: AppRoutes.listActivities,

                routes: {

                  AppRoutes.onBoading: (context) =>
                      new OnBoardScreen(),

                  AppRoutes.listActivities: (context) =>
                      new StoreConnector<AppState, List<ActivityViewModel>>(
                        converter: (store) => store.state.activities,
                        builder: (context, List<ActivityViewModel> viewModel) =>
                            new ListActivitiesScreen(
                              viewModel: viewModel,
                              openDetail: (_) => store.dispatch( SelectActivity(_) ),
                              deleteActivity:  (_) => store.dispatch( RemoveActivity(_) ),
                            ),
                      ),


                  AppRoutes.activityDetail: (context) =>
                      new StoreConnector<AppState, ActivityViewModel>(
                        converter: (store) => store.state.currentActivity,
                        builder: (context, ActivityViewModel viewModel) =>
                            new ActivityDetailScreen(
                              viewModel: viewModel,
                              editActivity: (_) => store.dispatch( SelectActivity(_) ),
                              deleteActivity: (_) => store.dispatch( RemoveActivity(_) ),
                              doActivity: (_) => store.dispatch( DoActivity(_) ),
                              undoActivity: (_) => store.dispatch( UndoActivity(_) ),
                            ),
                      ),


                  AppRoutes.addNewActivity : (context) =>
                      new StoreConnector<AppState, ActivityViewModel>(
                        converter: (_) => new ActivityViewModel(),
                        builder: (context, ActivityViewModel viewModel) =>
                            new AddNewActivityScreen(
                              viewModel: viewModel,
                              onSubmit: (_) => store.dispatch( AddActivity(_) ),
                            ),
                      ),


                  AppRoutes.editActivity : (context) =>
                      new StoreConnector<AppState, ActivityViewModel>(
                          converter: (store) => store.state.currentActivity,
                          builder: (context, ActivityViewModel viewModel) =>
                              new AddNewActivityScreen(
                                viewModel: viewModel,
                                onSubmit: (_) => store.dispatch( EditActivity(_) ),
                              ),
                      ),
                },

              ),

    );
  }
}
