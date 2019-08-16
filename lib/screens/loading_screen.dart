import 'package:flutter/material.dart';
import 'package:flutter_clima/services/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = 'b0f745b08e93733e0fd68303bd49aec2';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double latitude;
  double longitude;
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    Location location = Location();

    await location.getCurrentLocation();

    latitude = location.latitude;
    longitude = location.longitude;

    getData();
  }

  void getData() async {
    http.Response response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey');

    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);

      double temperature = decodedData['main']['temp'];
      int condition = decodedData['weather'][0]['id'];
      String cityName = decodedData['name'];

      print('Temperature: $temperature');
      print('Condition: $condition');
      print('City Name: $cityName');
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            print('Get Location Pressed!');
            getLocation();
          },
          child: Text('Get Location'),
        ),
      ),
    );
  }
}
