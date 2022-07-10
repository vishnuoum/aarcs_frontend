import 'package:flutter/material.dart';

class ListPageMal extends StatefulWidget {
  final Map arguments;
  const ListPageMal({Key? key,required this.arguments}) : super(key: key);

  @override
  State<ListPageMal> createState() => _ListPageMalState();
}

class _ListPageMalState extends State<ListPageMal> {

  bool loading=true;
  dynamic result=[];
  @override
  void initState() {
    load();
    super.initState();
  }

  void load()async{
    result = widget.arguments["type"]=="disease"?(await widget.arguments["obj"].getDiseasesMal()):(await widget.arguments["obj"].getSeedlingsMal());
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
        title: Text(widget.arguments["type"]=="disease"?"സസ്യ രോഗങ്ങൾ":"തൈകൾ"),
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
              child: Image.asset("assets/images/${result[index]["pic"]}.jpg", fit: BoxFit.cover),
              ),
            ),
            onTap: (){
              Navigator.pushNamed(context, "/cropMal",arguments: result[index]);
            },
          );
        },
      ),
    );
  }
}
