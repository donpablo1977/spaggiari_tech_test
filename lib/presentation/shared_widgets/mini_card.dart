import 'package:flutter/material.dart';
import 'package:spaggiari_tech_test/constants/dimensions.dart';
import 'package:spaggiari_tech_test/constants/strings.dart';

import '../../constants/colores.dart';
import '../../data/model/forecast.dart';

class MiniCard extends StatelessWidget {
  final Daily daily;
  const MiniCard({Key? key, required this.daily}) : super(key: key);

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
    }
    return iconFilename;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height / 20,
            left: MediaQuery.of(context).size.height / 40,
            right: MediaQuery.of(context).size.height / 40),
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 8,
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
            Image.asset(
              'assets/images/${_setAnimatedIconByWeather(daily.weather![0].main!)}',
              scale: 6,
            ),
            const SizedBox(
              height: 10,
            ),
            Wrap(
              children: [
                Text(
                  '${daily.temp!.max!.ceil().toString()}°C',
                  textScaleFactor: 1,
                  style: const TextStyle(
                      fontFamily: Strings.appFontFamily,
                      color: Colores.red,
                      fontSize: Dimensions.smallFontSize),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '${daily.temp!.min!.ceil().toString()}°C',
                  textScaleFactor: 1,
                  style: const TextStyle(
                      fontFamily: Strings.appFontFamily,
                      color: Colores.green,
                      fontSize: Dimensions.smallFontSize),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
