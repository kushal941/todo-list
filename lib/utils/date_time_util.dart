import 'package:intl/intl.dart';

/// Get the date in MMM dd, yyyy format.
String getDateInyMMMdFormat(DateTime dateTime) {
  String formattedDate = DateFormat.yMMMd().format(dateTime);

  return formattedDate;
}

/// Get the time in hh:mm a format.
String getTimeInhhmmaFormat(DateTime dateTime) {
  String formattedTime = DateFormat('hh:mm a').format(dateTime);

  return formattedTime;
}

