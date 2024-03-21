import 'package:intl/intl.dart';

class ValueFormatterHelper {
  static String convertDateToString(String dateTime) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy'); // Define the format you want
    try {
      // Parse the input string into a DateTime object
      DateTime parsedDateTime = DateTime.parse(dateTime);
      // Format the DateTime object back to a string
      return formatter.format(parsedDateTime);
    } catch (e) {
      // If parsing or formatting fails, return an error message or an empty string
      print('Error parsing date: $e');
      return 'Invalid date';
    }
  }
}
