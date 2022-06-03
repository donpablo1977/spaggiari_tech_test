import 'package:bloc/bloc.dart';
import 'package:spaggiari_tech_test/data/model/forecast.dart';
import 'package:spaggiari_tech_test/data/repo/weather_repo.dart';

import '../../data/model/geocode.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepo repo;
  WeatherBloc(this.repo) : super(WeatherInitial()) {
    on<WeatherEvent>((event, emit) async {
      if (event is WeatherFetchingEvent) {
        emit(WeatherFetchingState());
        Forecast forecast = await repo.fetchWeatherByCityName(event.geocode);
        if (forecast.daily != null) {
          if (forecast.daily!.isNotEmpty) {
            emit(WeatherFetchedState(forecast));
          } else {
            emit(WeatherEmptyState());
          }
        } else {
          emit(WeatherFailedState());
        }
      } else if (event is WeatherStartingEvent) {
        emit(WeatherInitial());
      } else if (event is WeatherGeocodingEvent) {
        emit(WeatherFetchingState());
        Geocode geocode =
            await repo.calculateCoordinatesByCityName(event.cityName);
        if (geocode.lat != null && geocode.lon != null) {
          emit(WeatherGecodedState(geocode));
        } else {
          emit(WeatherGeocodeFailedState());
        }
      }
    });
  }
}
