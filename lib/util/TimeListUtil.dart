
class TimeListUtil {

  static List<String> getAsStringList(int duration){
    return getAsList( duration ).map( (time) =>
                                          time.hour.toString().padLeft(2, '0') + ":" +
                                          time.minute.toString().padLeft(2, '0')

                                     ).toList();
  }

  static List<DateTime> getAsList( int duration){
    return getAsListAD( 0, 0, duration );
  }

  static List<DateTime> getAsListAD( int startHour, int starMin, int duration){

    List<DateTime> listOfTimes = <DateTime>[ ];

    int hour = startHour;
    int min = starMin;

    for( hour = 0 ; hour < 24 ; hour++){
      for( min = 0 ; min < 60 ; min= min + duration){
        listOfTimes.add(
            new DateTime(0, 0, 0, hour, min )
        );
      }
    }

    return listOfTimes;
  }

}