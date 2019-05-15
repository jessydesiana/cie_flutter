import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailMeeting extends StatefulWidget {

  List list;
  int index;
  DetailMeeting({this.index,this.list});

  @override
  _DetailMeetingState createState() => _DetailMeetingState();
}

class _DetailMeetingState extends State<DetailMeeting> {

  Future<List> getDataMeeting() async{
    final response = await http.post("http://rumahcantik29.000webhostapp.com/getdatameeting.php",
        body: {
          'groupid' : widget.list[widget.index]['group_id'],
        });
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list[widget.index]['group_name']),
      ),
      body: FutureBuilder<List>(
        future: getDataMeeting(),
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

    return new ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          child: new GestureDetector(
            child: new Card(
              child: new ListTile(
                title: list[i]['date'] != null ? new Text(list[i]['date'])
                : new Text('Data tidak ada'),
                leading: list[i]['description'] != null ? new Text(list[i]['description'],
                    style: TextStyle(
                        color: list[i]['description'] == 'Hadir'
                            ? Colors.blueAccent
                            : Colors.redAccent
                    ),
                )
                : new Text('Data tidak ada'),
                subtitle: list[i]['time_start'] != null || list[i]['time_finish'] != null ? new Text(list[i]['time_start'] + ' till ' +list[i]['time_finish'])
                    : new Text('Data tidak ada'),
                trailing: list[i]['location'] != null ? new Text(list[i]['location'],
                  style: TextStyle(color: Colors.lightGreen),)
                    : new Text('Data tidak ada'),
              ),
            ),
          ),
        );
      },
    );
  }
}