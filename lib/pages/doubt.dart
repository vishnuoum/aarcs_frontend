import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Doubt extends StatefulWidget {
  final Map arguments;
  const Doubt({Key? key,required this.arguments}) : super(key: key);

  @override
  State<Doubt> createState() => _DoubtState();
}

class _DoubtState extends State<Doubt> {

  bool loading = true;
  dynamic result=[{"id":"1","username":"Hello","district":"Thrissur","datetime":"2021/01/20","answer":"Hello"},
    {"id":"1","username":"Hello","district":"Thrissur","datetime":"2021/01/20","answer":"Hello"},
    {"id":"1","username":"Hello","district":"Thrissur","datetime":"2021/01/20","answer":"Hello"}];
  DateFormat dateFormat = DateFormat("dd/MM/yyyy hh:mm a");

  @override
  initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Answer the Query"),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.green[100]
        ),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            ListView(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.arguments["pic"]),
                      fit: BoxFit.cover
                    )
                  ),
                ),
                SizedBox(height: 10,),
                ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.person),
                  ),
                  title: Row(
                    children: [
                      Text(widget.arguments["username"],style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(width: 5,),
                      CircleAvatar(backgroundColor: Colors.green,radius: 3,),
                      SizedBox(width: 5,),
                      Text(widget.arguments["district"]),
                    ],
                  ),
                  subtitle: Text(dateFormat.format(DateTime.parse(widget.arguments["datetime"])).toString(),)
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                  child: Text(widget.arguments["query"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(widget.arguments["description"],style: TextStyle(fontSize: 16),),
                ),
                SizedBox(height: 20,),
                Center(
                  child: Text("Responses",style: TextStyle(color: Colors.green[800],fontSize: 17,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 10,),
                ListView.separated(
                  padding: EdgeInsets.only(bottom: 100),
                  shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              child: Icon(Icons.person),
                            ),
                            title: Text(result[index]["username"]),
                            subtitle: Text(result[index]["datetime"]),
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: Text(result[index]["answer"],style: TextStyle(fontSize: 17),),)
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 150
                ),
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(flex: 8,child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                          color: Colors.green[200]
                      ),
                      child: TextField(
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Write your response",
                          border: InputBorder.none
                        ),
                      ),
                    )),
                    SizedBox(width: 10,),
                    Expanded(child: IconButton(onPressed: null,icon: Icon(Icons.send),color: Colors.green,))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
