
class DurationUtil {

  static _getJustHours( Duration duration ){
    return duration.inHours - ( duration.inDays * 24 );
  }

  static _getJustMinutes( Duration duration ){
    return duration.inMinutes - ( duration.inDays * 24 * 60 ) - ( duration.inHours * 60 );
  }

  static String getAsText( Duration duration ){

    return (  duration.inDays > 0 ?
      duration.inDays.toString() + "d" :
        ( duration.inHours == 0 ?
            duration.inMinutes.toString() + "m":
            _getJustHours(duration).toString() + "h " + _getJustMinutes( duration ).toString() + "m"
        )
    );

  }

  static String getAsSimpleText( Duration duration ){

    return (  duration.inDays > 0 ?
                duration.inDays.toString() + " day" :
                ( duration.inHours == 0 ?
                    duration.inMinutes.toString() + " mins":
                    _getJustHours(duration).toString() + " hr " + _getJustMinutes( duration ).toString() + "mins"
                )
    );

  }

  static String getAsHHMM( Duration duration ){

    return duration == null ? null :
              duration.inHours.toString().padLeft( 2, '0' ) + ":" +
                  _getJustMinutes(duration).toString().padLeft( 2, '0' );

  }

  static Duration getDurationFromHHMM( String  durStr ){

    if( durStr == null  ){
      return null;

    } else {
      int hhPart = int.parse(durStr.split(":")[0]);
      int mmPart = int.parse(durStr.split(":")[1]);
      return new Duration(hours: hhPart, minutes: mmPart);

    }

  }

  static DateTime atMidnight( DateTime when ){
    return new DateTime(
            when.year,
            when.month,
            when.day,
          );
  }

}