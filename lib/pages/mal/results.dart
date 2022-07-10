import 'package:agri_app/services/dbservice.dart';
import 'package:flutter/material.dart';

class ResultMal extends StatefulWidget {
  final Map arguments;
  const ResultMal({Key? key,required this.arguments}) : super(key: key);

  @override
  State<ResultMal> createState() => _ResultMalState();
}

class _ResultMalState extends State<ResultMal> {

  dynamic result=[];

  bool loading=true;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData()async{
    print(widget.arguments);
    if(widget.arguments["type"]=="disease"){
      for(var i=0;i<widget.arguments["result"].length;i++){
        var res = await widget.arguments["obj"].getDiseaseMal(widget.arguments["result"][i]["index"]+1);
        result.add(res[0]);
      }
      setState(() {
        loading=false;
      });
    }
    else if(widget.arguments["type"]=="seedling"){
      for(var i=0;i<widget.arguments["result"].length;i++){
        var res = await widget.arguments["obj"].getSeedlingMal(widget.arguments["result"][i]["index"]+1);
        result.add(res[0]);
      }
      setState(() {
        loading=false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("പ്രെഡിക്ഷൻ"),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.pushReplacementNamed(context, "/listPageMal",arguments:widget.arguments);
        },
        label: Text("എല്ലാം കാണുക"),
      ),
      body: loading?Center(
        child: CircularProgressIndicator(),
      ):
      GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: result.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: (8 / 10),
            crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              SizedBox(
                height: 500,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, "/cropMal",arguments: result[index]);
                  },
                  child: Card(
                    elevation: 10,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Image.asset("assets/images/${result[index]['pic']}.jpg",fit: BoxFit.cover,),),
                ),
              ),
              Positioned(
                bottom: 20,
              right: 20,
              child: CircleAvatar(
                radius: 19,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  child: Text("${(widget.arguments["result"][index]["confidence"]*100).toStringAsFixed(0)}%",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)))
            ],
          );
        },
      ),
    );
  }
}
