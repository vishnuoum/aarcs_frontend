import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController calendarController=CalendarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Scheduler"),
        elevation: 0,
      ),
        body: Stack(
          children: [
            SfCalendar(
              controller: calendarController,
              todayHighlightColor: Colors.green,
              headerStyle: CalendarHeaderStyle(
                  textStyle: TextStyle(color: Colors.green,fontSize: 20,fontWeight: FontWeight.bold)
              ),
              headerHeight: 60,
              view: CalendarView.month,
              // showNavigationArrow: true,
              selectionDecoration: BoxDecoration(
                  border: Border.all(color: Colors.green,width: 2)
              ),
              dataSource: MeetingDataSource(_getDataSource()),
              monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode: MonthAppointmentDisplayMode.indicator),
              onTap: (calendarDetails){
                print(calendarDetails.appointments);
                calendarController.view=CalendarView.day;
                // calendarController.displayDate=DateTime.now();
              },
            ),
            Positioned(child: IconButton(onPressed: (){
                if(calendarController.view==CalendarView.day) calendarController.view=CalendarView.month;
                else calendarController.view=CalendarView.day;
              },icon: Icon(Icons.calendar_today,color: Colors.green,),
              tooltip: "Change Calendar view",
              iconSize: 28,
            ),top: 5,right: 8,),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: "Add new Event",
        child: Icon(Icons.add,size: 30),
      ),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
    DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    // meetings.add(Meeting(
    //     'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }
}


/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
