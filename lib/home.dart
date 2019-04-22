import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location;
  String humidity;
  String feelsLike;
  String wind;
  String temp;
  String country;
  String datetime;
  String date;
  String time;
  String condition;
  String newTemp;
  String iconUrl;
  int isDay;
  String newLocation;
  String zero;

  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = Text('Weather App');
  var _appbarIconSelect = Colors.yellow[600];
  var _backColour = Colors.yellowAccent[400];
  var result;
  int check = 0;
  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = TextField(
          onSubmitted: (value) {
            setState(() {
              location = value;
              this._searchIcon = Icon(Icons.search);
              this._appBarTitle = Text('Weather App');
              fetchData();
              checkData();

              print(check);
              if (check == 1006) {
                check = 0;
                Fluttertoast.showToast(
                    msg: 'Invalid Location',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            });
          },
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = Icon(Icons.search);
        this._appBarTitle = Text('Weather App');
      }
    });
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      backgroundColor: _appbarIconSelect,
      centerTitle: true,
      title: _appBarTitle,
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    location = '';
    humidity = '';
    feelsLike = '';
    wind = '';
    temp = '';
    country = '';
    location = 'kolkata';
    newTemp = '';
    condition = '';
    iconUrl = '';
    isDay = 0;
    newLocation = '';
    zero = '0';
    fetchData();
  }

  Future<Null> fetchData() async {
    http.Response response = await http.get(
        'https://api.apixu.com/v1/forecast.json?key=25123eb397c54676a3a92554191604&q=$location');
    print(response.body);
    result = json.decode(response.body);
    setState(() {
      var hum = result['current']['humidity'];
      humidity = hum.toString();
      var feel = result['current']['feelslike_c'];
      feelsLike = feel.toString();
      var win = result['current']['wind_kph'];
      wind = win.toString();
      var tem = result['current']['temp_c'];
      // if(tem<10)
      //   temp =zero+ tem.toString();
      // else  
        temp=tem.toString();
      
      country = result['location']['country'];
      datetime = result['location']['localtime'];
      date = datetime.substring(0, 10);
      time = datetime.substring(10);
      condition = result['current']['condition']['text'];
      newTemp = temp.substring(0, 2);

      newLocation = result['location']['name'];
      isDay = result['current']['is_day'];
      String icon = result['current']['condition']['icon'];
      String iconUrlt = icon.substring(2);
      iconUrl = 'https://$iconUrlt';
    });
  }

  checkData() {
    check = result['error']['code'];
  }

  _checkDayColor() {
    if (isDay == 1) {
      _backColour = Colors.yellowAccent[400];
      _appbarIconSelect = Colors.yellow[600];
    } else {
      _backColour = Colors.blueAccent[700];
      _appbarIconSelect = Colors.blue[900];
    }
  }

  Widget _buildLocation() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: Center(
        child: AutoSizeText(
          '$newLocation, $country',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buildDate() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
      child: Center(
        child: Text(
          '$date $time',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildTemp() {
    return Container(
      padding: EdgeInsets.fromLTRB(50, 49, 0, 0),
      child: AutoSizeText(
        '$newTemp',
        style: TextStyle(fontSize: 290, fontWeight: FontWeight.w500),
        maxLines: 1,
      ),
    );
  }

  Widget _buildDegree() {
    return Container(
      padding: EdgeInsets.fromLTRB(270, 110, 0, 0),
      child: Center(
        child: Text(
          '0',
          style: TextStyle(fontSize: 70, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _buildFeelsLike() {
    return Container(
      padding: EdgeInsets.fromLTRB(55, 370, 0, 0),
      child: Text(
        'Feels Like:  $feelsLike',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildHumidity() {
    return Container(
      padding: EdgeInsets.fromLTRB(55, 390, 0, 0),
      child: Text(
        'Humidity:  $humidity',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildWind() {
    return Container(
      padding: EdgeInsets.fromLTRB(55, 410, 0, 0),
      child: Text(
        'Wind:  $wind km/h',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildCondition() {
    return Container(
      padding: EdgeInsets.fromLTRB(55, 425, 0, 0),
      child: Text(
        condition,
        style: TextStyle(fontSize: 55, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: EdgeInsets.fromLTRB(310, 370, 0, 0),
      child: Image.network(iconUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    _checkDayColor();

    if (result == null) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.lightGreen,
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: _backColour,
        appBar: _buildBar(context),
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Stack(
              children: <Widget>[
                _buildLocation(),
                _buildDate(),
                _buildTemp(),
                _buildDegree(),
                _buildFeelsLike(),
                _buildHumidity(),
                _buildWind(),
                _buildCondition(),
                _buildIcon(),
              ],
            )
          ],
        ),
      );
    }
  }
}
