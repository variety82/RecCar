import 'package:flutter/material.dart';
import '../../widgets/common/footer.dart';
import 'package:table_calendar/table_calendar.dart';
import './calendar_utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:client/services/calendar_api.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  dynamic events = [];
  Map<DateTime, List<Event>> kEvents = {};

  @override
  void initState() {
    super.initState();
    // 대여 및 반납 일자도 캘린더에 표시
    getRentInfo(
      success: (dynamic response) {
        setState(() {
          events = response;
          for (int i = 0; i < events.length; i++) {
            // print(events[i]['rentalDate']);
            print(events[i]['rentalDate'].toString().substring(0, 11)+" 00:00:00.000Z");
            var temp = events[i]['rentalDate'].toString().substring(0, 10)+" 00:00:00.000";
            var rentalDate = DateTime.parse(temp).toUtc().subtract(const Duration(hours: 15));

            // var temp = DateTime.parse(events[i]['rentalDate'])
            //     .toUtc()
            //     .subtract(const Duration(hours: 15));
            if (kEvents.containsKey(rentalDate)) {
              kEvents[rentalDate]!.add(Event(i,
                  '대여', events[i]['carManufacturer']+" "+events[i]['carModel']+" "+events[i]['carNumber']));
            } else {
              kEvents.addAll({
                rentalDate: [
                  Event(i, '대여', events[i]['carManufacturer']+" "+events[i]['carModel']+" "+events[i]['carNumber']),
                ]
              });
            }
            temp = events[i]['returnDate'].toString().substring(0, 10)+" 00:00:00.000";
            var returnDate = DateTime.parse(temp).toUtc().subtract(const Duration(hours: 15));
            if (kEvents.containsKey(returnDate)) {
              kEvents[returnDate]!.add(Event(i,
                  '반납', events[i]['carManufacturer']+" "+events[i]['carModel']+" "+events[i]['carNumber']));
            } else {
              kEvents.addAll({
                returnDate: [
                  Event(i, '반납', events[i]['carManufacturer']+" "+events[i]['carModel']+" "+events[i]['carNumber']),
                ]
              });
            }
          }
        });
      },
      fail: (error) {
        print('렌트 내역 호출 오류: $error');
      },
    );
    // 등록한 일정도 표시
    getEvents(
      success: (dynamic response) {
        setState(() {
          events = response;
          for (int i = 0; i < events.length; i++) {
            var temp = events[i]['calendarDate'];
            var eventDate = DateTime.parse(temp).toUtc().subtract(const Duration(hours: 15));
            if (kEvents.containsKey(eventDate)) {
              kEvents[eventDate]!.add(Event(events[i]['calendarId'],
                  events[i]['title'], events[i]['memo']));
            } else {
              kEvents.addAll({
                eventDate: [
                  Event(events[i]['calendarId'], events[i]['title'], events[i]['memo']),
                ]
              });
            }
          }
        });
      },
      fail: (error) {
        print('렌트 내역 호출 오류: $error');
      },
    );
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 80,
              ),
              Expanded(
                flex: 9,
                child: Container(
                  color: Colors.white,
                  child: Card(
                    elevation: 0,
                    child: TableCalendar(
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        leftChevronIcon:
                            const Icon(Icons.arrow_back_ios_rounded),
                        rightChevronIcon:
                            const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      // rangeStartDay: _rangeStart,
                      // rangeEndDay: _rangeEnd,
                      // calendarFormat: _calendarFormat,
                      // rangeSelectionMode: _rangeSelectionMode,
                      // eventLoader: ,
                      eventLoader: _getEventsForDay,
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      onDaySelected: _onDaySelected,
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      calendarStyle: CalendarStyle(
                        canMarkersOverflow: false,
                        markersAutoAligned: true,
                        markerSize: 6,
                        markerMargin:
                            const EdgeInsets.symmetric(horizontal: 0.5),
                        markersAlignment: Alignment.bottomCenter,
                        markersMaxCount: 4,
                        selectedDecoration: ShapeDecoration(
                            shape: CircleBorder(side: BorderSide.none),
                            color: Theme.of(context).primaryColor),
                        markerDecoration: ShapeDecoration(
                            shape: CircleBorder(side: BorderSide.none),
                            color: Theme.of(context).primaryColor),
                        todayDecoration: ShapeDecoration(
                            shape: CircleBorder(side: BorderSide.none),
                            color: Theme.of(context).primaryColorLight),
                        // holidayTextStyle: TextStyle(color: Colors.red,),
                        weekendTextStyle: TextStyle(
                          color: Colors.red,
                        ),
                        outsideDaysVisible: false,
                        rangeHighlightColor: Theme.of(context).primaryColor,
                        rangeHighlightScale: 1,
                        rangeStartTextStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.0,
                        ),
                        rangeStartDecoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        rangeEndTextStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.0,
                        ),
                        rangeEndDecoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        withinRangeDecoration:
                            const BoxDecoration(shape: BoxShape.circle),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 0,
                thickness: 1.1,
                indent: 10,
                endIndent: 10,
              ),
              Expanded(
                flex: 4,
                child: Card(
                  elevation: 0,
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      if(value.length==0)
                        return Center(child: Text("일정이 없습니다"));
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  blurRadius: 2.0,
                                  spreadRadius: 0.0,
                                )
                              ],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              onTap: () => print(
                                  '${value[index].title} ${value[index].memo}'),
                              title: Text('${value[index].title}',
                                  style: TextStyle(color: Color(0xFF6A6A6A))),
                              subtitle: Text('${value[index].memo}'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Footer(),
            ],
          ),
        ),
        Positioned(
          child: TextButton(
            onPressed: () {
              addEvent();
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF6A6A6A),
                    blurRadius: 1.5,
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
          bottom: 70,
          right: 15,
        ),
      ],
    );
  }

  void addEvent() {
    FocusNode _unUsedFocusNode = FocusNode();
    // showDialog(context: context, builder: (BuildContext context)
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                        "일정 등록",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "TITLE",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Container(
                              height: 30,
                              child: TextField(
                                onTapOutside: (PointerDownEvent event) {
                                  FocusScope.of(context)
                                      .requestFocus(_unUsedFocusNode);
                                },
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  )),
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Text(
                        "DATE ",
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                      Container(
                        child: SfDateRangePicker(
                            view: DateRangePickerView.month,
                            monthViewSettings:
                                const DateRangePickerMonthViewSettings(
                                    firstDayOfWeek: 7),
                            onSelectionChanged:
                                (DateRangePickerSelectionChangedArgs args) {
                              print(args.value);
                            },
                            todayHighlightColor: Theme.of(context).primaryColor,
                            selectionColor: Theme.of(context).primaryColor,
                            headerStyle: DateRangePickerHeaderStyle(
                              textAlign: TextAlign.center,
                              textStyle: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                            monthCellStyle: DateRangePickerMonthCellStyle(
                              todayTextStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            selectionTextStyle:
                                const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("MEMO",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).secondaryHeaderColor,
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 90,
                        child: TextField(
                          maxLines: 3,
                          onTapOutside: (PointerDownEvent event) {
                            FocusScope.of(context)
                                .requestFocus(_unUsedFocusNode);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .secondaryHeaderColor)),
                            labelText: '',
                          ),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => {Navigator.pop(context)},
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 13,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                  )
                                ],
                              ),
                              child: Text(
                                "취소",
                                style: TextStyle(
                                  color: Color(0xFF453F52),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => {},
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 13,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFE0426F)),
                              child: Text(
                                "등록",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
