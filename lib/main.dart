import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
int v3 = 0;
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}


Future getdata(url) async {
  http.Response response = await http.get(url);
  return response.body;
}

class MyApp extends StatefulWidget {
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  String url;
  String status = "City not selected";

  var data;

  int v1 = 0;
  int v2 = 0;

  int v4 = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.cyan,
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Image.network(
                    'https://www.nasa.gov/images/content/483897main_Global-PM2.5-map.JPG'),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Text(
                  "Check the rate of pollution near you",
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) {
                    url = 'https://pollution-report.herokuapp.com/' +
                        value.toString();
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'City name',
                    //labelStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                    hintText: "Enter your city",
                    //hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: () async {
                      data = await getdata(url);
                      var decodedData = jsonDecode(data);
                      setState(() {
                        status = "City selected";
                        v1 = decodedData['o3'];
                        v2 = decodedData['pm10'];
                        v3 = decodedData['pm25'];
                        v4 = decodedData['uvi'];
                      });
                    },
                    child: const Text('SUBMIT', style: TextStyle(fontSize: 15)),
                  ),
                  RaisedButton(
                      child: Icon(Icons.refresh),
                      onPressed: () {
                        setState(() {
                          status = "Select another city";
                          v1 = 0;
                          v2 = 0;
                          v3 = 0;
                          v4 = 0;
                        });
                      }),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  status,
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "ozone: " + v1.toString() + " " + " microgram/metre^3",
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "particulate matter 10: " +
                      v2.toString() +
                      " " +
                      "microgram/metre^3",
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "particulate matter 2.5: " +
                      v3.toString() +
                      " " +
                      "microgram/m^3",
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Ultra violet index: " +
                      v4.toString() +
                      " " +
                      "microgram/m^3",
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 40,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      onPressed: () {
                        if (v3 > 1 && v3 <= 50) {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Green()));
                        } else if (v3 > 50 && v3 <= 100) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Yellow()));
                        } else if (v3 > 100 && v3 <= 150) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Orange()));
                        } else if (v3 == 0) {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Error()));
                        } else {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Red()));
                        }
                      },
                      color: Colors.blue[900],
                      textColor: Colors.white,
                      child: Text('precautions'),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Green extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Green Zone"),
          backgroundColor: Colors.lightGreen,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Area('0-50', 'Good', 'No Risk', 'You are safe',
              textStyleWithColor(Colors.green)),
        ));
  }
}

class Yellow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Yellow Zone"),
          backgroundColor: Colors.amberAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Area(
              '51-101',
              'Moderate',
              'Moderate concern for a very small number of people who are unusually sensitive to air pollution',
              'People with respiratory disease like asthama should limit prolonge outdoor exertion',
              textStyleWithColor(Colors.amberAccent)),
        ));
  }
}

class Orange extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Orange Zone"),
          backgroundColor: Colors.orange,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Area(
              '101-150',
              'Unheathy for sensitive group',
              'General public is not likely to be affected',
              'People with respiratory disease like asthama should limit outdoor prolonge exertion',
              textStyleWithColor(Colors.orange)),
        ));
  }
}

class Red extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Red Zone"),
          backgroundColor: Colors.red,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Area(
              '151-250',
              'Unheathy',
              'General public will be affected,Sensitive people experience more serious health effects',
              'People with respiratory disease,especially children like asthama should limit prolonge outdoor exertion',
              textStyleWithColor(Colors.red)),
        ));
  }
}
//Table row elemenets

TextStyle textstyle() {
  return TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);
}

TextStyle textStyleWithColor(Color clr) {
  return TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: clr);
}

Widget Area(String aqi, String apl, String hi, String cs, TextStyle ts) {
  return Center(
    child: Table(border: TableBorder.all(color: Colors.black), children: [
      TableRow(children: [
        Text("AQI", style: ts),
        Text(
          aqi,
          style: textstyle(),
        ),
      ]),
      TableRow(children: [
        Text("Air Pollution level", style: ts),
        Text(
          apl,
          style: textstyle(),
        ),
      ]),
      TableRow(children: [
        Text("Health Implications", style: ts),
        Text(
          hi,
          style: textstyle(),
        ),
      ]),
      TableRow(children: [
        Text("Cautionary statement", style: ts),
        Text(
          cs,
          style: textstyle(),
        ),
      ]),
    ]),
  );
}

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Container(
              child: Image.asset('images/error.gif'),
            ),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyApp()));
            },
            child: Text("Enter a valid city name"),
          ),
        ],
      ),
    );
  }
}
