import 'package:flutter/material.dart';
import 'package:cie_app/beranda.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

String studentId = '';
String studentName = '';

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        fontFamily: 'Nunito',
      ),

      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/Beranda' : (BuildContext context)=> new Beranda(studentId: studentId, studentName: studentName,),
        '/Login' : (BuildContext context)=> new MyHomePage(),
    },
    );
  }
}

class MyHomePage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController user=new TextEditingController();
  TextEditingController pass=new TextEditingController();

  String msg='';

  Future<List> _login() async {
    final response = await http.post("http://rumahcantik29.000webhostapp.com/login.php", body: {
      "username": user.text,
      "password": pass.text,
    });

    var datauser = json.decode(response.body);

    if(datauser.length==0){
      setState(() {
        msg="Login Fail";
      });
    }else{
      Navigator.pushReplacementNamed(context, '/Beranda');

      setState(() {
        studentId = datauser[0]['people_id'];
        studentName = datauser[0]['firstname'];
      });
    }

    return datauser;
  }

  @override
  Widget build(BuildContext context) {

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: user,
      decoration: InputDecoration(
        hintText: 'Student Id',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );

    final password = TextField(
      autofocus: false,
      controller: pass,
      obscureText: true,
      onChanged: (text){
        if(text.trim().length == 6){
          _login();
        }
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(32.0),
        ),

      ),

    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _login();
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage('assets/city.jpg'),
            fit: BoxFit.cover
          )
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              //loginButton,
            ],
          ),
        ),
      ),
    );

//    return Scaffold(
//      appBar: AppBar(title: Text("Login"),),
//      body: Container(
//        child: Center(
//          child: Column(
//            children: <Widget>[
//              Text("Username",style: TextStyle(fontSize: 18.0),),
//              TextField(
//                controller: user,
//                decoration: InputDecoration(
//                    hintText: 'Username'
//                ),
//              ),
//              Text("Password",style: TextStyle(fontSize: 18.0),),
//              TextField(
//                controller: pass,
//                obscureText: true,
//                decoration: InputDecoration(
//                    hintText: 'Password'
//                ),
//              ),
//
//              RaisedButton(
//                child: Text("Login"),
//                onPressed: (){
//                  _login();
//                },
//              ),
//
//              Text(msg,style: TextStyle(fontSize: 20.0,color: Colors.red),)
//
//
//            ],
//          ),
//        ),
//      ),
//    );
  }
}

