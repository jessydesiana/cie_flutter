import 'dart:convert';

import 'package:cie_app/detailmeeting.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Beranda extends StatelessWidget {

  Beranda({this.studentId, this.studentName});
  final String studentId;
  final String studentName;
  
  Future<List> getDataGroup() async{
    final response = await http.post("http://rumahcantik29.000webhostapp.com/getdata.php",
    body: {
      'username' : studentId,
    });
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    print('student name beranda : '+ studentName);
    print('student id beranda : '+studentId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Group'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app),
          onPressed: (){
            Navigator.pushReplacementNamed(context,'/Login');
          }),
        ],
      ),
      body: FutureBuilder<List>(
        future: getDataGroup(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? new ItemList(
            list: snapshot.data,
          )
              : new Center(
            child: new CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    print('list beranda ' + list[0]['group_name']);

    return new ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
//          padding: const EdgeInsets.all(10.0),
          child: new GestureDetector(
            onTap: ()=>Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context)=> new DetailMeeting(list:list , index: i,)
                )
            ),
            child: new Card(
              child: new ListTile(
                title: new Text(list[i]['group_name']),
                leading: new Icon(Icons.group),
                subtitle: new Text(list[i]['firstname'] + ' ' +list[i]['surename']),
              ),
            ),
          ),
        );
      },
    );
  }
}