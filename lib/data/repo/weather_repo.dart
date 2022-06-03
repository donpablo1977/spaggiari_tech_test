import 'package:spaggiari_tech_test/data/api/weather_api.dart';
import 'package:spaggiari_tech_test/data/model/forecast.dart';
import 'package:spaggiari_tech_test/data/model/geocode.dart';

class WeatherRepo {
  final WeatherAPI _api = WeatherAPI();

  Future<Forecast> fetchWeatherByCityName(Geocode geocode) async {
    return await _api.fetchWeatherByCityName(geocode);
  }

  Future<Geocode> calculateCoordinatesByCityName(String cityName) async {
    return await _api.calculateCoordinatesByCityName(cityName);
  }
}
