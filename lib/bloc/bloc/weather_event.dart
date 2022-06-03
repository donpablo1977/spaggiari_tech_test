part of 'weather_bloc.dart';

abstract class WeatherEvent {}

class WeatherStartingEvent extends WeatherEvent {}

class WeatherGeocodingEvent extends WeatherEvent {
  final String cityName;

  WeatherGeocodingEvent(this.cityName);
}

class WeatherFetchingEvent extends WeatherEvent {
  final Geocode geocode;

  WeatherFetchingEvent(this.geocode);
}
