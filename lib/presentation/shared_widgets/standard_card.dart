import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaggiari_tech_test/constants/dimensions.dart';
import 'package:spaggiari_tech_test/constants/strings.dart';
import 'package:spaggiari_tech_test/data/model/forecast.dart';

import '../../bloc/bloc/weather_bloc.dart';
import '../../constants/colores.dart';
import 'custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StandardCard extends StatefulWidget {
  final WeatherFetchedState state;
  final Function hook;
  final Function forecastPanelHook;
  final List<Daily> data;
  const StandardCard(
      {Key? key,
      required this.state,
      required this.hook,
      required this.forecastPanelHook,
      required this.data})
      : super(key: key);

  @override
  State<StandardCard> createState() => _StandardCardState();
}

class _StandardCardState extends State<StandardCard> {
  double customButtonVerticalPosition = 100;
  int tapOnMeLabelOpacity = 150;

  //Il metodo setta l'animazione corretta in base alla tipologia di previsione prensente nella response
  String _setAnimatedIconByWeather(String weather) {
    String iconFilename = '';
    switch (weather) {
      case 'Clouds':
        iconFilename = 'cloudly.gif';
        break;
      case 'Clear':
        iconFilename = 'sunny.gif';
        break;
      case 'Rain':
        iconFilename = 'rainy.gif';
        break;
      default:
        iconFilename = 'sunny.gif';
        break;
    }
    return iconFilename;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Il widget contiene un Custom Button parametrizzato
        //utile a resettare la UI portando l'utente nuovamente nella
        //schermata di ricerca
        AnimatedPositioned(
          duration: const Duration(milliseconds: 350),
          left: MediaQuery.of(context).size.width / 2 -
              MediaQuery.of(context).size.width / 24,
          top: customButtonVerticalPosition,
          child: CustomButton(
              hook: () {
                //Come in precedenza, anche in questo caso si è preferito usare un setState
                //per velocizzare lo sviluppo trattandosi di una piccola animazione e di un prototipo non
                //destinato agli utenti finali
                setState(() {
                  customButtonVerticalPosition = 100;
                });
                widget.forecastPanelHook();
              },
              iconData: Icons.close),
          onEnd: () {
            if (customButtonVerticalPosition == 100) {
              context.read<WeatherBloc>().add(WeatherStartingEvent());
              widget.data.clear();
            }
          },
        ),
        //In questo caso viene utilizzato un GestureDetector Widget per ovviare
        //al problema relativo all'InkWell non funzionante all'iterno di uno Stack widget
        GestureDetector(
          onTap: () {
            widget.hook();
            setState(() {
              customButtonVerticalPosition = 10;
              tapOnMeLabelOpacity = 0;
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(
              MediaQuery.of(context).size.width / 8,
            ),
            decoration: const BoxDecoration(
                color: Colores.background,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Colores.shadowColor,
                      blurRadius: 5,
                      offset: Dimensions.standardOffset)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Sono utilizzate icone animate in formato .gif caricate direttamente dal folder assets
                Image.asset(
                  'assets/images/${_setAnimatedIconByWeather(widget.state.forecast.daily![0].weather![0].main!)}',
                  scale: 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.temperature,
                  textScaleFactor: 1,
                  style: const TextStyle(
                      fontFamily: Strings.appFontFamily,
                      color: Colores.blue,
                      fontSize: Dimensions.smallFontSize),
                ),
                Wrap(
                  children: [
                    Text(
                      '${widget.state.forecast.daily![0].temp!.max!.ceil().toString()}°C',
                      textScaleFactor: 1,
                      style: const TextStyle(
                          fontFamily: Strings.appFontFamily,
                          color: Colores.red,
                          fontSize: Dimensions.largeFontSize),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${widget.state.forecast.daily![0].temp!.min!.ceil().toString()}°C',
                      textScaleFactor: 1,
                      style: const TextStyle(
                          fontFamily: Strings.appFontFamily,
                          color: Colores.green,
                          fontSize: Dimensions.largeFontSize),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.pressure,
                  textScaleFactor: 1,
                  style: const TextStyle(
                      fontFamily: Strings.appFontFamily,
                      color: Colores.blue,
                      fontSize: Dimensions.smallFontSize),
                ),
                Text(
                  '${widget.state.forecast.daily![0].pressure.toString()} hPa',
                  textScaleFactor: 1,
                  style: const TextStyle(
                      fontFamily: Strings.appFontFamily,
                      color: Colores.yellow,
                      fontSize: Dimensions.largeFontSize),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.humidity,
                  textScaleFactor: 1,
                  style: const TextStyle(
                      fontFamily: Strings.appFontFamily,
                      color: Colores.blue,
                      fontSize: Dimensions.smallFontSize),
                ),
                Text(
                  '${widget.state.forecast.daily![0].humidity.toString()}%',
                  textScaleFactor: 1,
                  style: const TextStyle(
                      fontFamily: Strings.appFontFamily,
                      color: Colores.orange,
                      fontSize: Dimensions.largeFontSize),
                ),
                const SizedBox(
                  height: 30,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  child: Text(
                    'TAP ON ME',
                    textScaleFactor: 1,
                    style: TextStyle(
                        fontFamily: 'Helvetica-Cond',
                        color: Colores.red.withAlpha(tapOnMeLabelOpacity),
                        fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
