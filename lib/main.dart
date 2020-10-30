import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main(){
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.teal,
      brightness: Brightness.dark,
    ),
    home: HomePage(),

  ),);
}

//fetch data online using http
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final String url = 'http://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=d83e3c53361c4b06a300ba416b059b53';
  List data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData()  async {
    var response = await http.get(
        Uri.encodeFull(url),
        headers:  {
          "Accept": "application/json",
        },
    );
    print(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson['articles'];
    });
    print(data);

    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'fatch data online',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.tealAccent,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index){
              return Column(
                children: [
                  Card(
                    margin: EdgeInsets.all(20),
                    borderOnForeground: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(image: NetworkImage(data[index]['urlToImage']), fit: BoxFit.fill,),
                              Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 5)),
                              Text(data[index]['title'], style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
                              Text(data[index]['publishedAt'], style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),textAlign: TextAlign.start,),
                              Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 5)),
                              Text(data[index]['description'], style: TextStyle(fontSize: 17),),
                              Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 5)),
                              RaisedButton.icon(onPressed:  ()  {
                                  launch(data[index]['url']);
                                },
                                  icon: Icon(Icons.forward),
                                  label: Text('more details')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}




