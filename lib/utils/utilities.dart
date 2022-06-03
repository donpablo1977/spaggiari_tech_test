import 'package:flutter/material.dart';
import 'package:spaggiari_tech_test/constants/dimensions.dart';
import 'package:spaggiari_tech_test/constants/strings.dart';

class Utilities {
  static void showMessage(
      BuildContext context, Color color, String message, IconData iconData) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 12,
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(iconData, size: 30, color: Colors.white),
                const SizedBox(width: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(message,
                      textScaleFactor: 1,
                      style: const TextStyle(
                          fontFamily: Strings.appFontFamily,
                          fontSize: Dimensions.mediumFontSize)),
                ),
              ],
            ),
          ),
        )));
  }
}
