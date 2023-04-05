import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTime _focusedDay = DateTime.parse(
      DateTime.now().toString().substring(0, 11) + "00:00:00.000Z");
  DateTime _selectedDay = DateTime.parse(
      DateTime.now().toString().substring(0, 11) + "00:00:00.000Z");
  dynamic events = [];
  Map<DateTime, List<Event>> kEvents = {};

  TextEditingController _titleController = TextEditingController();
  TextEditingController _memoController = TextEditingController();
  DateRangePickerController _dateController = DateRangePickerController();
  DateTime _inputedCalendarDate = DateTime.parse("0000-00-00 00:00:00.000Z");
  String _inputedTitle = "";
  String _inputedMemo = "";

  Map<String, dynamic> _buildCalendarInfoBody() {
    return {
      "calendarDate": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .format(_inputedCalendarDate!),
      "title": _inputedTitle,
      "memo": _inputedMemo,
      "isAuto": false,
    };
  }

  Map<String, dynamic> _buildCalendarInfoBody2(int id) {
    return {
      "calendarId": id,
      "calendarDate": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .format(_inputedCalendarDate),
      "title": _inputedTitle,
      "memo": _inputedMemo,
      "isAuto": false,
    };
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _focusedDay = DateTime.parse(
          DateTime.now().toString().substring(0, 11) + "00:00:00.000Z");
    });
    setState(() {
      _selectedDay = DateTime.parse(
          DateTime.now().toString().substring(0, 11) + "00:00:00.000Z");
    });
    // 일정 불러오기
    getEvents(
      success: (dynamic response) {
        setState(() {
          events = response;
          for (int i = 0; i < events.length; i++) {
            var temp = (DateTime.parse(events[i]['calendarDate'])
                        .add(const Duration(hours: 9)))
                    .toString()
                    .substring(0, 11) +
                "00:00:00.000Z";
            var eventDate = DateTime.parse(temp);
            if (kEvents.containsKey(eventDate)) {
              kEvents[eventDate]!.add(Event(events[i]['calendarId'],
                  events[i]['title'], events[i]['memo']));
            } else {
              kEvents.addAll({
                eventDate: [
                  Event(events[i]['calendarId'], events[i]['title'],
                      events[i]['memo']),
                ]
              });
            }
          }
        });
      },
      fail: (error) {
        print('캘린더 내역 호출 오류: $error');
      },
    );
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay));
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
      _selectedEvents.value = _getEventsForDay(selectedDay);
    });
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
                      if (value.length == 0)
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
                              onTap: () => {
                                showDetailCalender(value[index].id,
                                    value[index].title, value[index].memo)
                              },
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
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
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
                                  controller: _titleController,
                                  onTapOutside: (PointerDownEvent event) {
                                    FocusScope.of(context)
                                        .requestFocus(_unUsedFocusNode);
                                  },
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                    ),
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
                              // onSelectionChanged:
                              //     (DateRangePickerSelectionChangedArgs args) {
                              //   print(args.value);
                              // },
                              controller: _dateController,
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
                            controller: _memoController,
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
                              onPressed: () => {addCalendar()},
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
            ),
          );
        });
  }

  void addCalendar() {
    setState(() {
      _inputedTitle = _titleController.text;
    });
    setState(() {
      _inputedMemo = _memoController.text;
    });
    setState(() {
      _inputedCalendarDate = _dateController.selectedDate ??
          DateTime.parse("0000-00-00 00:00:00.000Z");
    });
    if (_inputedTitle != "" &&
        _inputedCalendarDate != DateTime.parse("0000-00-00 00:00:00.000Z")) {
      postEvent(
        success: (dynamic response) {
          // 바로 반영이 안돼서 일단 딜레이 주기
          sleep(const Duration(seconds: 2));
        },
        fail: (error) {
          print('일정 등록 오류: $error');
        },
        body: _buildCalendarInfoBody(),
      );
      Navigator.pushNamed(context, '/calendar');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
        SnackBar(
          content: Center(child: Text("제목과 날짜는 필수 입력값입니다.", style: TextStyle(color: Colors.white))),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(milliseconds: 1000),
          behavior: SnackBarBehavior.floating,
          // action: SnackBarAction(
          //   label: '닫기',
          //   textColor: Colors.white,
          //   onPressed: () => {},
          // ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
      );
    }
  }

  // 일정 상세보기 (수정, 삭제 기능 추가하기)
  void showDetailCalender(int id, String title, String memo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 200,
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${_focusedDay.toString().split(" ")[0]} 일정",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                    ),
                    Container(
                      width: 55,
                      margin: EdgeInsets.zero,
                      child: TextButton(
                        onPressed: () {
                          modifyCalendar(id, title, memo, _focusedDay);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "수정",
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 55,
                      margin: EdgeInsets.zero,
                      child: TextButton(
                        onPressed: () {
                          deleteCalendar(id);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "삭제",
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1.5,
                  height: 0,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: 50,
                      child: Text(
                        "TITLE",
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: Color(0xFF6A6A6A),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: 50,
                      child: Text(
                        "MEMO",
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    if (memo == "")
                      Text(
                        "메모가 없습니다",
                        style: TextStyle(
                          color: Color(0xFFD9D9D9),
                        ),
                      ),
                    if (memo != "")
                      Text(
                        memo,
                        style: TextStyle(
                          color: Color(0xFF6A6A6A),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => {Navigator.pop(context)},
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 3,
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
                          "닫기",
                          style: TextStyle(
                            color: Color(0xFF453F52),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void modifyCalendar(int id, String title, String memo, DateTime date) {
    FocusNode _unUsedFocusNode = FocusNode();
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
                        "일정 수정",
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
                                controller: _titleController..text = title,
                                onTapOutside: (PointerDownEvent event) {
                                  FocusScope.of(context)
                                      .requestFocus(_unUsedFocusNode);
                                },
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                                  ),
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
                            // onSelectionChanged:
                            //     (DateRangePickerSelectionChangedArgs args) {
                            //   print(args.value);
                            // },
                            controller: _dateController..selectedDate = date,
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
                          controller: _memoController..text = memo,
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
                            onPressed: () => {putCalendar(id)},
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
                                "수정",
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

  void putCalendar(int id) {
    setState(() {
      _inputedTitle = _titleController.text;
    });
    setState(() {
      _inputedMemo = _memoController.text;
    });
    setState(() {
      _inputedCalendarDate = _dateController.selectedDate ?? DateTime.now();
    });
    putEvent(
      success: (dynamic response) {
        // 바로 반영이 안돼서 일단 딜레이 주기
        sleep(const Duration(seconds: 2));
      },
      fail: (error) {
        print('일정 수정 오류: $error');
      },
      body: _buildCalendarInfoBody2(id),
    );
    Navigator.pop(context);
    Navigator.pushNamed(context, '/calendar');
  }

  void deleteCalendar(int id) {
    deleteEvent(
      success: (dynamic response) {
        // 바로 반영이 안돼서 일단 딜레이 주기
        sleep(const Duration(seconds: 2));
      },
      fail: (error) {
        print('일정 수정 오류: $error');
      },
      calendarId: id,
    );
    Navigator.pop(context);
    Navigator.pushNamed(context, '/calendar');
  }
}
