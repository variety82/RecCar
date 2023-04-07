import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

// Event 클래스 생성
class Event {
  final int id;
  final String title;
  final String memo;
  final bool auto;
  const Event(this.id, this.title, this.memo, this.auto);
}


final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 5, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + 5, kToday.month, kToday.day);