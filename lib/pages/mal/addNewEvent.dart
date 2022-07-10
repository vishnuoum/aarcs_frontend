import 'package:agri_app/services/dbservice.dart';
import 'package:flutter/material.dart';

class AddNewEventMal extends StatefulWidget {
  const AddNewEventMal({Key? key}) : super(key: key);

  @override
  _AddNewEventMalState createState() => _AddNewEventMalState();
}

class _AddNewEventMalState extends State<AddNewEventMal> {

  TextEditingController eventName=TextEditingController(text: "");
  DBService dbService=DBService();

  DateTime? date=DateTime(2000);
  late TimeOfDay? startTime;
  String start="ആരംഭ സമയം തിരഞ്ഞെടുക്കുക";
  late TimeOfDay? endTime;
  String end="അവസാനിക്കുന്ന സമയം തിരഞ്ഞെടുക്കുക";

  Future<void> alertDialog(var text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('അലെർട്'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ഓക്കേ'),
              onPressed: () {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.green
        ),
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
              Text("ഷെഡ്യൂളിലേക്ക് പുതിയ ഇവന്റ് ചേർക്കുക",style: TextStyle(color: Colors.green,fontSize: 25,fontWeight: FontWeight.bold),),
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
                      hintText: 'ഇവന്റിന്റെ പേര്'
                  ),
                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: ()async{
                  date= await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2021), lastDate: DateTime(2050));
                  setState(() {});
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]
                  ),
                  child: Text(date==DateTime(2000)?"ഒരു തീയതി തിരഞ്ഞെടുക്കുക":"${date!.day}/${date!.month}/${date!.year}",style: TextStyle(fontSize: 16,color: date==DateTime(2000)?Colors.grey[700]:Colors.black),)
                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: ()async{
                  startTime= await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  setState((){
                    start=startTime!.format(context).toString();
                  });
                },
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200]
                    ),
                    child: Text(start,style: TextStyle(fontSize: 16,color: start=="ആരംഭ സമയം തിരഞ്ഞെടുക്കുക"?Colors.grey[700]:Colors.black),)
                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: ()async{
                  endTime= await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  setState((){
                    end=endTime!.format(context).toString();
                  });
                },
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200]
                    ),
                    child: Text(end,style: TextStyle(fontSize: 16,color: end=="അവസാനിക്കുന്ന സമയം തിരഞ്ഞെടുക്കുക"?Colors.grey[700]:Colors.black),)
                ),
              ),
              SizedBox(height: 20,),
              TextButton(style: TextButton.styleFrom(padding: EdgeInsets.all(18),backgroundColor: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: ()async{
                    if(eventName.text!="" && date!=DateTime(2000) && start!="ആരംഭ സമയം തിരഞ്ഞെടുക്കുക" && end!="അവസാനിക്കുന്ന സമയം തിരഞ്ഞെടുക്കുക"){
                      await dbService.addEvent(
                        eventName: eventName.text,
                        fromTime: DateTime(date!.year,date!.month,date!.day,startTime!.hour,startTime!.minute),
                        toTime: DateTime(date!.year,date!.month,date!.day,endTime!.hour,endTime!.minute),
                      );
                      await alertDialog("ഇവന്റ് ചേർത്തു");
                      Navigator.pop(context);
                    }
                    else{
                      alertDialog("ദയവായി ഫോം പൂർണ്ണമായും പൂരിപ്പിക്കുക");
                    }
                  },
                  child: Text("ഇവന്റ് ചേർക്കുക",style: TextStyle(color: Colors.white,fontSize: 17),)
              )
            ],
          ),
        ),
      ),
    );
  }
}
