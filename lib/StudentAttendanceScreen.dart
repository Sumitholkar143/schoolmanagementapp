import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'DatabaseOp.dart';
import 'ProgresBar/ProgreesBar.dart';

class Student {
  Map<DateTime, bool> attendanceData;

  Student(this.attendanceData);
}

class StudentAttendanceScreen extends StatefulWidget {
  @override
  _StudentAttendanceScreenState createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  int p = 0, a = 0;
  bool calender = false, progres = true;
  Student selectedStudent = Student(
    {},
  );

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  void initState() {
    super.initState();
    getPresent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Attendance'),
      ),
      body: Column(
        children: [
          Visibility(
              visible: progres,
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Center(
                      child:
                          AnimatedCircularProgressBar() //CircularProgressIndicator(color: Colors.blue,)
                      ,
                    ),
                  ],
                ),
              )),
          Visibility(
            visible: calender,
            child: TableCalendar(
              firstDay: DateTime.utc(DateTime.now().year),
              lastDay: DateTime.utc(DateTime.now().year + 1),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onDaySelected: (selectedDay, focusedDay) {},
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  );
                },
                todayBuilder: (context, date, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  );
                },
                markerBuilder: (context, date, events) {
                  final isPresent = selectedStudent.attendanceData[
                      DateTime(date.year, date.month, date.day).toLocal()];
                  print(isPresent);
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      shape: BoxShape.rectangle,
                      color: date.weekday == 7 || date.isAfter(_focusedDay)
                          ? Colors.white.withOpacity(0.2)
                          : isPresent != null && isPresent
                              ? Colors.green.shade400.withOpacity(0.2)
                              : Colors.red.shade200.withOpacity(0.2),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          Visibility(
            visible: calender,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.red.shade200.withOpacity(0.2)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Absent'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.green.shade200.withOpacity(0.2)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Present')
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> getPresent() async {
    var p = await DatabaseOp.getAttandance();
    List<String> dateComponents;
    int year, month, day;
    DateTime dateTime;
    for (String a in p) {
      String dateString = a.toString();
      dateComponents = dateString.split('-');
      year = int.parse(dateComponents[0]);
      month = int.parse(dateComponents[1]);
      day = int.parse(dateComponents[2]);
      dateTime = DateTime(year, month, day);
      selectedStudent.attendanceData[dateTime] = true;
    }
    setState(() {
      progres = false;
      calender = true;
    });
    print(selectedStudent.attendanceData);
  }
}
