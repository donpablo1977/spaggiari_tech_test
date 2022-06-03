import 'dart:math';
import 'package:flutter/material.dart';
import 'package:spaggiari_tech_test/constants/dimensions.dart';
import 'package:spaggiari_tech_test/constants/strings.dart';
import '../../../../constants/colores.dart';

class QuoteText extends StatefulWidget {
  const QuoteText({Key? key}) : super(key: key);

  @override
  State<QuoteText> createState() => _QuoteTextState();
}

class _QuoteTextState extends State<QuoteText> {
  int? _randomNumber;

  int _generateRandomNumber() {
    return Random().nextInt(Strings.quotes.length);
  }

  @override
  void initState() {
    super.initState();
    _randomNumber = _generateRandomNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 1.2,
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 20,
              right: MediaQuery.of(context).size.width / 20),
          child: Text(
            Strings.quotes[_randomNumber!],
            textAlign: TextAlign.center,
            textScaleFactor: 1,
            style: const TextStyle(
                fontFamily: Strings.appFontFamily,
                color: Colores.blue,
                fontSize: Dimensions.mediumFontSize),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width / 1.2,
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 20,
              right: MediaQuery.of(context).size.width / 20),
          child: Text(
            Strings.authors[_randomNumber!],
            textAlign: TextAlign.center,
            textScaleFactor: 1,
            style: const TextStyle(
                color: Colores.blue,
                fontFamily: Strings.appFontFamily,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.smallFontSize),
          ),
        ),
      ],
    );
  }
}
