import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../Constants/strings.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  TextEditingController _cityController = new TextEditingController();
  final String OPEN_WEATHER_API_KEY = dotenv.env['OPEN_WEATHER_API_KEY']!;

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
            ),
          ],
        ),
      ),
    );
  }
}
