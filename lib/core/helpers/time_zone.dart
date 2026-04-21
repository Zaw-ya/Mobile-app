import 'package:timezone/data/latest.dart' as tz;

class TimeZone {
  Future initializeTimeZone() async {
    tz.initializeTimeZones();
  }
}
