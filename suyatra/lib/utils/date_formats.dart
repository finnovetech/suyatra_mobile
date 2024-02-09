import 'package:intl/intl.dart';


String formatDate(String? dateString) {
  if(dateString== null) {
    return "";
  }
  return "${DateFormat.MMM().format(DateTime.parse(dateString).toLocal())} ${DateFormat.d().format(DateTime.parse(dateString).toLocal())}, ${DateFormat.y().format(DateTime.parse(dateString).toLocal())}";
}

String formatDateStandard(String? dateString) {
  if(dateString== null) {
    return "";
  }
  return DateFormat("MM-d-y").format(DateTime.parse(dateString).toLocal());
}

String formatDateTime(String? dateString) {
  if(dateString== null) {
    return "";
  }
  return DateFormat.yMd().format(DateTime.parse(dateString).toLocal());
}

String formatDateInLanguage(String dateString) {
    DateTime givenDate = DateTime.parse(dateString).toLocal();
    DateTime currentDate = DateTime.now().toLocal();
    if(DateFormat.yMMMEd().format(givenDate) == DateFormat.yMMMEd().format(currentDate)) {
      return "Today";
    } else if(DateFormat.yMMMEd().format(givenDate) == DateFormat.yMMMEd().format(currentDate.subtract(const Duration(days: 1)))) {
      return "Yesterday, ${DateFormat.MMMd().format(DateTime.parse(dateString).toLocal())}";
    }
    return DateFormat.yMMMEd().format(DateTime.parse(dateString).toLocal());
}

String formatDateInLanguageDynamic(String dateString) {
    String date = DateFormat("yyyy-MMM-dd").format(DateTime.parse(dateString).toLocal());
    if(date == DateFormat("yyyy-MMM-dd").format(DateTime.now().toLocal())) {
      String todayDate = "Today, ${DateFormat.jm().format(DateTime.parse(dateString).toLocal())}";
      return todayDate;
    } else if(date == DateFormat("yyyy-MMM-dd").format(DateTime.now().subtract(const Duration(days: 1)).toLocal())) {
      String yesterdayDate = "Yesterday, ${DateFormat.MMMd().format(DateTime.parse(dateString).toLocal())}";
      return yesterdayDate;
    }
     else {
      return DateFormat.yMMMEd().format(DateTime.parse(dateString).toLocal());
    }    
}

String formatDateInLanguageOnlyMonth(String dateString) {
  return DateFormat.yMMMd().format(DateTime.parse(dateString).toLocal());
}


String formatDateInLanguageNoYear(String dateString) {
  return DateFormat.MMMd().format(DateTime.parse(dateString).toLocal());
}


String formatDateInLanguageNoDay(String dateString) {
  return DateFormat.yMMMd().format(DateTime.parse(dateString).toLocal());
}


///Used for date range filter in apiService.dart file
///Might not need to add .toLocal() for this function
String formatDateYMD(String dateString) {
  String month;
  if(DateTime.parse(dateString).month < 10) {
    month = "0${DateTime.parse(dateString).month}";
  } else {
    month = "${DateTime.parse(dateString).month}";
  }
  
  return "${DateFormat.y().format(DateTime.parse(dateString))}-$month-${DateFormat.d().format(DateTime.parse(dateString))}";
}

bool isNotExpired(String dateString) {
  int value = DateTime.parse(dateString).compareTo(DateTime.now());
  if(value > 0) {
    return true;
  } else {
    return false;
  }
}

bool canDeleteTransaction(String dateString) {
  Duration duration = DateTime.now().difference(DateTime.parse(dateString));
  if(duration.inDays <= 1) {
    return true;
  } else {
    return false;
  }
}

/// Find the first date of the week which contains the provided date.
DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday==7?0:dateTime.weekday));
}

/// Find last date of the week which contains provided date.
DateTime findLastDateOfTheWeek(DateTime dateTime) {
  return dateTime.add(Duration(days: (7 - (dateTime.weekday==7?0:(dateTime.weekday)))));
}


DateTime findFirstDateOfPreviousWeek(DateTime dateTime) {
  final DateTime sameWeekDayOfLastWeek =
  dateTime.subtract(const Duration(days: 7));
  return findFirstDateOfTheWeek(sameWeekDayOfLastWeek);
}

DateTime findLastDateOfPreviousWeek(DateTime dateTime) {
  final DateTime sameWeekDayOfLastWeek =
  dateTime.subtract(const Duration(days: 7));
  return findLastDateOfTheWeek(sameWeekDayOfLastWeek);
}

String formatDateToAgo(DateTime datetime, {bool full = true}) {
    DateTime now = DateTime.now();
    DateTime ago = datetime;
    Duration dur = now.difference(ago);
    int days = dur.inDays;
    int years = days ~/ 365;
    int months =  (days - (years * 365)) ~/ 30;
    int weeks = (days - (years * 365 + months * 30)) ~/ 7;
    int rdays = days - (years * 365 + months * 30 + weeks * 7).toInt();
    int hours = (dur.inHours % 24).toInt();
    int minutes = (dur.inMinutes % 60).toInt();
    int seconds = (dur.inSeconds % 60).toInt();
    var diff = {
      "d":rdays,
      "w":weeks,
      "m":months,
      "y":years,
      "s":seconds,
      "i":minutes,
      "h":hours
    };

    Map str = {
      'y':'year',
      'm':'month',
      'w':'week',
      'd':'day',
      'h':'hour',
      'i':'minute',
      's':'second',
    };

    str.forEach((k, v){
      if (diff[k]! > 0) {
          str[k] = '${diff[k]} $v${diff[k]! > 1 ? 's' : ''}';
      } else {
          str[k] = "";
      }
    });
    str.removeWhere((index, ele)=>ele == "");
    List<String> tlist = [];
    str.forEach((k, v){
      tlist.add(v);
    });
    if(full){
      return str.isNotEmpty?"${tlist.join(", ")} ago":"Just Now";
    }else{
      return str.isNotEmpty?"${tlist[0]} ago":"Just Now";
    }
}



bool isBeforeTwoDays(String dateString) {
  DateTime createdDate = DateTime.parse(dateString);
  return createdDate.isBefore(DateTime.now().subtract(const Duration(days: 2)));
}

String readFirebaseTimestamp(dynamic timestamp) {
  int timeStampValue = DateTime.parse(timestamp.toDate().toString()).millisecondsSinceEpoch;
  var now = DateTime.now();
  var format = DateFormat('HH:mm a');
  var date = DateTime.fromMicrosecondsSinceEpoch(timeStampValue * 1000);
  var diff = date.difference(now);
  var time = '';

  if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = '${diff.inDays} DAY AGO';
    } else {
      time = '${diff.inDays} DAYS AGO';
    }
  }

  return time;
}