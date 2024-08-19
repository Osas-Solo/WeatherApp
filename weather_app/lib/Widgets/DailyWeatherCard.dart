import 'package:flutter/material.dart';
import 'package:weather_app/Models/DailyWeatherData.dart';

class DailyWeatherCard extends StatelessWidget {
  final ThreeHourWeatherData weatherData;

  const DailyWeatherCard({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    const weatherIconUrl = 'https://openweathermap.org/img/wn/';

    String dateName = '';
    String dateDetail = '${weatherData.dtTxt.day/weatherData.dtTxt.month}';

    if (DateTime.now().difference(weatherData.dtTxt) == 0) {
      dateName = 'Today';
    } else if (DateTime.now().difference(weatherData.dtTxt) == 1) {
      dateName = 'Tomorrow';
    } else {
      dateName = '${weatherData.dtTxt.toString()}';
    }

    return Card(
      child: Container(
        padding: EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(dateDetail),
            Text(dateName),
            Image.network('$weatherIconUrl/${weatherData.weather[0].icon}.png'),
            Text(weatherData.weather[0].description),
            Text('${weatherData.main.temp}\u00B0C'),
          ],
        ),
      ),
    );
  }
}
