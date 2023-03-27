import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

// Event 클래스 생성
class Event {
  final int id;
  final String title;
  final String memo;
  const Event(this.id, this.title, this.memo);
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(100, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(1, (index) => Event(index, 'Event $item | ${index + 1}', 'hi')))
  ..addAll({
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 1, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + 1, kToday.month, kToday.day);