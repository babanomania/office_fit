
class NumberTimesListUtil {

  static List<String> getAsList(int max, String predicate){

    List<String> listOfTimes = <String>[ ];
    for( int counter = 0 ; counter < max ; counter++){
      listOfTimes.add(
          counter.toString() + " " + predicate
      );
    }

    return listOfTimes;
  }

}