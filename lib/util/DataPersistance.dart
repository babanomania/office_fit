import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class DataPersistance {

  SharedPreferences prefs;
  static const String DATA_KEY = "OFFICE_FIT_DATA";
  static const String DATA_KEY_LN = "OFFICE_FIT_NOTIFIED";

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

  set lastNotified( DateTime when ) => prefs.setString( DATA_KEY_LN , when.toString() );

  get lastNotified => prefs.getString( DATA_KEY_LN ) == null ?
                            null :
                            DateTime.parse( prefs.getString( DATA_KEY_LN ) );

}