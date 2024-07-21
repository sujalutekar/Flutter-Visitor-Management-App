import 'package:cloud_firestore/cloud_firestore.dart';

void deleteAfterThreeMonths() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final QuerySnapshot snapshot = await firestore.collection('entries').get();

  // last date in cloud firestore
  String dateString = snapshot.docs.first.id;

  // converting that date to DateTime
  final DateTime date = _parseDateString(dateString);

  final DateTime currentDate = DateTime.now();

  final DateTime threeMonthsAgo =
      DateTime(currentDate.year, currentDate.month - 3, currentDate.day);

  if (date.isBefore(threeMonthsAgo)) {
    await firestore.collection('entries').doc(dateString).delete();
    // await firestore
    //     .collection('entries')
    //     .doc(dateString)
    //     .collection('singleDayEntries')
    //     .doc()
    //     .delete();
    // print('Doc Deleted');
  }

  print('LATEST NEW DATE: $date');
  print('THREE MONTHS AGO DATE: $threeMonthsAgo');
  print('DATE: ${date.isBefore(threeMonthsAgo)}');
}

DateTime _parseDateString(String dateString) {
  // Example format: "April 1, 2024"
  final List<String> parts = dateString.split(' ');
  final String monthString = parts[0];
  final int day = int.parse(parts[1].replaceAll(',', ''));
  final int year = int.parse(parts[2]);
  final int month = _parseMonth(monthString);
  return DateTime(year, month, day);
}

int _parseMonth(String monthString) {
  switch (monthString.toLowerCase()) {
    case 'january':
      return 1;
    case 'february':
      return 2;
    case 'march':
      return 3;
    case 'april':
      return 4;
    case 'may':
      return 5;
    case 'june':
      return 6;
    case 'july':
      return 7;
    case 'august':
      return 8;
    case 'september':
      return 9;
    case 'october':
      return 10;
    case 'november':
      return 11;
    case 'december':
      return 12;
    default:
      throw FormatException('Invalid month');
  }
}
