import 'dart:convert';

import 'package:flutter/material.dart';
import '../util/util.dart' as util;
import 'dart:async';
import 'package:http/http.dart' as http;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
//
//  void showStuff() async {
//    Map data= await getWeather(util.appId, util.defaultCity);
//    print(data);
//  }


  String _cityEntered;
  //future is use to expert/receive whats coming back from the other activity
  Future _goToCityScreen(BuildContext context) async {
    //here you receive whats coming ack from the changes Activity
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new ChangedCity();
    }));

    //validation
    if(results != null && results.containsKey('enter')){
      _cityEntered=results['enter'];
      print(_cityEntered);
      //print("From the first screen: " + results['enter'].toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Klimatic"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.menu),
              onPressed: (){_goToCityScreen(context) ;}
          )
        ],
      ),
     //stack use to lay view over one another
     body: new Stack(
       children: <Widget>[
         new Center(
           //background
           child: new Image.asset('images/umbrella.png',
           width: 490.0,
           height: 12000.0,
           fit: BoxFit.fill,) ,
         ),
         new Container(
           alignment: Alignment.topRight,
           margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
           child: new
           //if city is null set to defaultCity else back to city
           Text('${_cityEntered == null ? util.defaultCity : _cityEntered}',
           style: cityStyle(),),
         ),

         new Container(
           alignment: Alignment.center,
           child:  new Image.asset('images/light_rain.png'),
         ),

         //container that will have our weather data
          updateTempWidget(_cityEntered),
//         new Container(
//           margin: const EdgeInsets.fromLTRB(30.0, 310.0, 0.0, 0.0),
//           //alignment: Alignment.center,
//
//         )
       ],
     ),
    );
  }


  Future<Map> getWeather(String appId,String city) async{
     String apiUrl="http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=imperial";

     http.Response response= await http.get(apiUrl);

     return jsonDecode(response.body);

  }

  //what i want out of the api keys
  Widget updateTempWidget(String city){
    return new FutureBuilder(
      //if the city is null, set to defaultCity else is City
      future: getWeather(util.appId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
        //where we get all the json data, we setup the widgets etc
        if(snapshot.hasData){
          Map content=snapshot.data;// content have the whole api map
          return new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new ListTile(
                  title: new Text(content['main']['temp'].toString()+" F",
                  style: new TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 49.9,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),),

                 subtitle: new ListTile(
                   title: new Text(
                     'Humidity: ${content['main']['humidity'].toString()}\n'
                         'Min: ${content['main']['temp_min'].toString()} F\n'
                         'Max: ${content['main']['temp_max'].toString()} F',
                     style: extralData(),
                   ),
                 ),
                )
              ],
            ),
          );
        } else{
          return new Container();
        }
    });
  }
}

// second Screen
class ChangedCity extends StatelessWidget {

  var _cityFieldController=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change City'),
        centerTitle:true
      ),

      body: new Stack(
        children: <Widget>[
          new Center(
            child:  new Image.asset('images/white_snow.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,),
          ),

          new ListView(
            //this listView is more like helping to arrange the view in a well align horizontal manner
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter City'
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),

              new ListTile(
                title: new FlatButton(
                    onPressed: (){
                      Navigator.pop(context,
                      {
                        'enter':_cityFieldController.text
                      });
                    },
                    textColor: Colors.white70,
                    color: Colors.redAccent,
                    child: new Text('Get Weather')),
              )
            ],
          )
        ],
      ),
    );
  }
}


TextStyle cityStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic
  );
}

TextStyle extralData(){
  return new TextStyle(
      color: Colors.white70,
      fontSize: 17.0,
      fontStyle: FontStyle.normal
  );
}

TextStyle tempStyle(){
  return new TextStyle(
      color: Colors.white,
      fontSize: 49.9,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal
  );
}