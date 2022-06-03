import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spaggiari_tech_test/constants/strings.dart';
import 'package:spaggiari_tech_test/data/model/forecast.dart';
import 'package:spaggiari_tech_test/data/model/geocode.dart';

class WeatherAPI {
  Future<Forecast> fetchWeatherByCityName(Geocode geocode) async {
    Forecast? fore;
    //La chiamata utilizza il metodo onecall delle API suggerite per recuperare i dati meteo correnti
    //e quelli per i successivi 7 giorni, escludendo le info aggiornate per ora e minuti. Inoltre vengono esclusi gli alert meteo
    try {
      http.Response response = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/onecall?lat=${geocode.lat}&lon=${geocode.lon}&exclude=current,hourly,minutely,alerts&appid=${Strings.apiKey}&units=metric'),
      );
      if (response.statusCode == 200) {
        fore = Forecast.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      throw Exception(e);
    }

    return fore!;
  }

  Future<Geocode> calculateCoordinatesByCityName(String cityName) async {
    Geocode? geocode;
    try {
      //La chiamata utilizza il geocoding per elaborare le coordinate della città inserita dall'utente
      //richieste dal servizio relativo alle previsioni meteo
      http.Response response = await http.get(
        Uri.parse(
            'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=5&appid=${Strings.apiKey}'),
      );
      if (response.statusCode == 200) {
        geocode = (jsonDecode(response.body) as Iterable)
            .map((e) => Geocode.fromJson(e))
            .toList()
            .last;
      }
    } catch (e) {
      throw Exception(e);
    }
    return geocode!;
  }
}
