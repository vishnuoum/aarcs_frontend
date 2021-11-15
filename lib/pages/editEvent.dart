import 'package:flutter/material.dart';

class EditEvent extends StatefulWidget {
  const EditEvent({Key? key}) : super(key: key);

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {

  Map arg={};
  TextEditingController eventName=TextEditingController();
  DateTime date=DateTime(2000);
  String start="Pick a Starting Time",end="Pick an Ending Time";
  late TimeOfDay startTime,endTime;
  var db;


  Future<void> alertDialog(var text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Do you want to delete the event?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context).pop();
                await db.removeEvent(id:id);
                alertDialog("The event has been deleted");
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    if(arg.length==0){
      arg=ModalRoute.of(context)!.settings.arguments as Map;
      print(arg);
      eventName.text=arg["appointment"].eventName;
      db=arg["db"];
      DateTime fromTime=arg["appointment"].from;
      DateTime toTime=arg["appointment"].to;
      date=DateTime(fromTime.year,fromTime.month,fromTime.day);
      startTime=TimeOfDay(hour: fromTime.hour,minute: fromTime.minute);
      start=startTime.format(context);
      endTime=TimeOfDay(hour: toTime.hour,minute: toTime.minute);
      end=endTime.format(context);
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.green
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Form(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            children: [
              Text("Add New Event to Schedule",style: TextStyle(color: Colors.green,fontSize: 25,fontWeight: FontWeight.bold),),
              SizedBox(height: 50,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200]
                ),
                child: TextField(
                  controller: eventName,
                  focusNode: null,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Event Name'
                  ),
                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: ()async{
                  date= (await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2021), lastDate: DateTime(2050)))!;
                  setState(() {});
                },
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200]
                    ),
                    child: Text(date==DateTime(2000)?"Pick a Date":"${date.day}/${date.month}/${date.year}",style: TextStyle(fontSize: 16,color: date==DateTime(2000)?Colors.grey[700]:Colors.black),)
                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: ()async{
                  startTime= (await showTimePicker(context: context, initialTime: startTime))!;
                  setState((){
                    start=startTime.format(context).toString();
                  });
                },
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200]
                    ),
                    child: Text(start,style: TextStyle(fontSize: 16,color: start=="Pick a Starting Time"?Colors.grey[700]:Colors.black),)
                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: ()async{
                  endTime= (await showTimePicker(context: context, initialTime: endTime))!;
                  setState((){
                    end=endTime.format(context).toString();
                  });
                },
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200]
                    ),
                    child: Text(end,style: TextStyle(fontSize: 16,color: end=="Pick an Ending Time"?Colors.grey[700]:Colors.black),)
                ),
              ),
              SizedBox(height: 20,),
              TextButton(style: TextButton.styleFrom(padding: EdgeInsets.all(18),backgroundColor: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: ()async{
                    if(eventName.text!="" && date!=DateTime(2000) && start!="Pick a StartingTime" && end!="Pick an Ending Time"){
                      await db.editEvent(
                        id:arg["appointment"].id,
                        eventName: eventName.text,
                        fromTime: DateTime(date.year,date.month,date.day,startTime.hour,startTime.minute),
                        toTime: DateTime(date.year,date.month,date.day,endTime.hour,endTime.minute),
                      );
                      await alertDialog("Event has been edited");
                      Navigator.pop(context);
                    }
                    else{
                      alertDialog("Please fill the form completely");
                    }
                  },
                  child: Text("Edit Event",style: TextStyle(color: Colors.white,fontSize: 17),)
              ),
              SizedBox(height: 10,),
              TextButton(style: TextButton.styleFrom(padding: EdgeInsets.all(18),backgroundColor: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: ()async{
                    await deleteDialog(arg["appointment"].id);
                    Navigator.pop(context);
                  },
                  child: Text("Remove Event",style: TextStyle(color: Colors.white,fontSize: 17),)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
