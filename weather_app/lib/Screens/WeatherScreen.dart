import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Models/CurrentCityWeatherData.dart';
import 'package:weather_app/Models/DailyWeatherData.dart';

import '../Constants/strings.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  TextEditingController _cityController = new TextEditingController();
  final String OPEN_WEATHER_API_KEY = dotenv.env['OPEN_WEATHER_API_KEY']!;
  final String OPEN_WEATHER_API_URL = 'https://api.openweathermap.org/data/2.5';
  CurrentCityWeatherData? _currentCityWeatherData = null;
  DailyWeatherData? _dailyWeatherData = null;
  List<ThreeHourWeatherData> fiveDayWeatherDataList = [];

  Future<void> _searchWeather() async {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(Strings.retrievingWeatherData)));

    final String cityName = _cityController.text;

    var cityCurrentWeatherURL = Uri.parse('$OPEN_WEATHER_API_URL/weather?q=$cityName&appID=$OPEN_WEATHER_API_KEY');
    final cityCurrentWeatherResponse = await http.get(cityCurrentWeatherURL);

    if (cityCurrentWeatherResponse.statusCode == 200) {
      _currentCityWeatherData = currentCityWeatherDataFromJson(cityCurrentWeatherResponse.body);
    } else if (cityCurrentWeatherResponse.statusCode == 404) {
      _currentCityWeatherData = null;
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(Strings.cityNotFound)));
    } else {
      _currentCityWeatherData = null;
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(Strings.sorryAnErrorOccurred)));
    }

    if (_currentCityWeatherData != null) {
      var dailyWeatherURL = Uri.parse('$OPEN_WEATHER_API_URL/forecast?lat=${_currentCityWeatherData!.coord.lat}&lon=${_currentCityWeatherData!.coord.lon}&appid=$OPEN_WEATHER_API_KEY&units=metric');
      final dailyWeatherResponse = await http.get(dailyWeatherURL);

      print('Daily Response:');
      print(dailyWeatherResponse.body);

      if (dailyWeatherResponse.statusCode == 200) {
        _dailyWeatherData = dailyWeatherDataFromJson(dailyWeatherResponse.body);

        print('Count: ${_dailyWeatherData!.list.length}');
        for (var currentData in _dailyWeatherData!.list) {
          print('Current: ');
          print(currentData.dtTxt);
        }
      } else if (dailyWeatherResponse.statusCode == 404) {
        _dailyWeatherData = null;
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(Strings.cityNotFound)));
      } else {
        _dailyWeatherData = null;
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(Strings.sorryAnErrorOccurred)));
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: ListView(
          children: [
            SearchBar(
              controller: _cityController,
              hintText: Strings.enterCityName,
              leading: const Icon(Icons.search),
              onSubmitted: (text) {
                _searchWeather();
              },
            ),
          ],
        ),
      ),
    );
  }
}
