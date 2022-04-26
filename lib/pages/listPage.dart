import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  final Map arguments;
  const ListPage({Key? key,required this.arguments}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  bool loading=true;
  dynamic result=[];
  @override
  void initState() {
    load();
    super.initState();
  }

  void load()async{
    result = widget.arguments["type"]=="disease"?(await widget.arguments["obj"].getDiseases()):(await widget.arguments["obj"].getSeedlings());
    print(result.length);
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.arguments["type"]=="disease"?"Plant Diseases":"Seedlings"),
      ),
      body: loading?Center(
        child: CircularProgressIndicator(),
      ):ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            title: Text(result[index]["name"]),
            subtitle: Text(result[index]["details"],overflow: TextOverflow.ellipsis,),
            leading: Container(
              height: 150,
              clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10)),
              child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 64,
                maxHeight: 64,
                maxWidth: 64,
                minWidth: 64
              ),
              child: Image.asset("assets/images/${result[index]["name"]}.jpg", fit: BoxFit.cover),
              ),
            ),
            onTap: (){
              Navigator.pushNamed(context, "/crop",arguments: result[index]);
            },
          );
        },
      ),
    );
  }
}
