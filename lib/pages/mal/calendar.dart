import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarMal extends StatefulWidget {
  const CalendarMal({Key? key}) : super(key: key);

  @override
  _CalendarMalState createState() => _CalendarMalState();
}

class _CalendarMalState extends State<CalendarMal> {

  CalendarController calendarController=CalendarController();
  var db;
  late CalendarDataSource datasource;
  Map arg={};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    datasource.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if(arg.length==0) {
      arg = ModalRoute
          .of(context)!
          .settings
          .arguments as Map;
      db = arg["db"];
      datasource=MeetingDataSource(_getDataSource());
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("ഇവന്റ് ഷെഡ്യൂളർ"),
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
              dataSource: datasource,
              monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
              onTap: (calendarDetails)async{
                if(calendarController.view==CalendarView.month){
                  calendarController.view=CalendarView.day;
                }
                else if(calendarController.view==CalendarView.day && (calendarDetails.appointments![0] is Meeting)){
                  print(calendarDetails.appointments![0].id);
                  await Navigator.pushNamed(context, "/editEventMal",arguments: {"appointment":calendarDetails.appointments![0],"db":db});
                  setState(() {
                    datasource=MeetingDataSource(_getDataSource());
                  });
                  // print(datasource);
                  datasource.notifyListeners(CalendarDataSourceAction.add,_getDataSource());
                }
                setState(() {});
                // calendarController.displayDate=DateTime.now();
              },
            ),
            Positioned(child: IconButton(onPressed: (){
                if(calendarController.view==CalendarView.day) calendarController.view=CalendarView.month;
                else calendarController.view=CalendarView.day;
              },icon: Icon(Icons.calendar_today,color: Colors.green,),
              tooltip: "കലണ്ടർ കാഴ്ച മാറ്റുക",
              iconSize: 28,
            ),top: 5,right: 8,),
            Positioned(child: IconButton(onPressed: (){
              setState(() {
                datasource=MeetingDataSource(_getDataSource());
              });
              // print(datasource);
              datasource.notifyListeners(CalendarDataSourceAction.add,_getDataSource());
            },icon: Icon(Icons.refresh,color: Colors.green,),
              tooltip: "റിഫ്രഷ്",
              iconSize: 30,
            ),top: 5,right: 60,),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          await Navigator.pushNamed(context, "/addNewEventMal");
          setState(() {
            datasource=MeetingDataSource(_getDataSource());
          });
          // print(datasource);
          datasource.notifyListeners(CalendarDataSourceAction.add,_getDataSource());
        },
        tooltip: "പുതിയ ഇവന്റ് ചേർക്കുക",
        child: Icon(Icons.add,size: 30),
      ),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    db.getEvents().then((events){
      for(int i=0;i<events.length;i++){
        meetings.add(Meeting(id: events[i]["id"],eventName: events[i]["eventName"], from: DateTime.parse(events[i]["fromTime"]), to: DateTime.parse(events[i]["toTime"])));
      }
    });
    // meetings.add(Meeting(
    //     eventName: 'Conference', from: startTime, to: endTime));
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
  Meeting({required this.id,required this.eventName, required this.from, required this.to, this.background=const Color(0xFF0F8644), this.isAllDay=false});

  int id;
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
