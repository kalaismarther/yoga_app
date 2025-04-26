import 'package:intl/intl.dart';

class DateHelper {
  static String ddmmmyyyyStringFormat(date) {
    try {
      if (date.isEmpty) {
        return '';
      } else {
        String formattedDate = DateFormat('dd MMM, yyyy')
            .format(DateFormat('yyyy-MM-dd').parse(date));

        return formattedDate;
      }
    } catch (e) {
      return '';
    }
  }

  static String yyyymmddStringFormat(String date) {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd')
          .format(DateFormat('dd MMM, yyyy').parse(date));

      return formattedDate;
    } catch (e) {
      return '';
    }
  }

  static DateTime? convertStringToDateFormat(String enteredDate) {
    try {
      DateTime date =
          DateFormat('dd MMM, yyyy').parse(ddmmmyyyyStringFormat(enteredDate));

      return date;
    } catch (e) {
      return null;
    }
  }

  static String formatDateTime(String dateTimeString) {
    try {
      if (dateTimeString.isEmpty) {
        return '';
      }
      // Parsing the input string to a DateTime object
      DateTime dateTime = DateTime.parse(dateTimeString);

      // Defining the format: "dd MMM, yyyy HH:mm"
      String formattedDate = DateFormat('dd MMM, yyyy HH:mm').format(dateTime);

      return formattedDate;
    } catch (e) {
      return '';
    }
  }
}
