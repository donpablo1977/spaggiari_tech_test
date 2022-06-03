part of 'weather_bloc.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherFetchingState extends WeatherState {}

class WeatherFetchedState extends WeatherState {
  final Forecast forecast;

  WeatherFetchedState(this.forecast);
}

class WeatherGecodedState extends WeatherState {
  final Geocode geocode;

  WeatherGecodedState(this.geocode);
}

class WeatherEmptyState extends WeatherState {}

class WeatherFailedState extends WeatherState {}

class WeatherGeocodeFailedState extends WeatherState {}
