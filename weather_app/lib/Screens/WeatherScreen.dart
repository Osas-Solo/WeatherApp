import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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

  Future<void> _searchWeather() async {
    final String cityName = _cityController.text;

    var cityCurrentWeatherURL = Uri.parse('$OPEN_WEATHER_API_URL/weather?q=$cityName&appID=$OPEN_WEATHER_API_KEY');
    final cityCurrentWeatherResponse = await http.get(cityCurrentWeatherURL);

    print('Response status:');
    print(cityCurrentWeatherResponse.body);
    
    if (cityCurrentWeatherResponse.statusCode == 200) {
      print('Response:');
      print(cityCurrentWeatherResponse.body);
    } else if (cityCurrentWeatherResponse.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(Strings.cityNotFound)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(Strings.sorryAnErrorOccurred)));
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
