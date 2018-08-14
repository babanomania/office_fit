import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

class DataPersistance {

  SharedPreferences prefs;
  final String DATA_KEY = "OFFICE_FIT_DATA";
  static DataPersistance _instance = new DataPersistance();

  static Future<DataPersistance> get instance async {
    if( _instance.prefs == null )
      _instance.prefs = await SharedPreferences.getInstance();

    return _instance;
  }

  save( data ){
    prefs.setString( DATA_KEY , data );
  }

  retreive() => prefs.getString( DATA_KEY );

}