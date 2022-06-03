import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../constants/colores.dart';
import '../../../../constants/dimensions.dart';
import '../../../../constants/strings.dart';
import '../../../../data/model/forecast.dart';
import '../../../shared_widgets/mini_card.dart';

class MiniPanel extends StatefulWidget {
  final List<Daily> daily;
  final String searchedCityName;
  const MiniPanel(
      {Key? key, required this.daily, required this.searchedCityName})
      : super(key: key);

  @override
  State<MiniPanel> createState() => _MiniPanelState();
}

class _MiniPanelState extends State<MiniPanel> {
  double? extraDataPanelPosition = -1000;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
        bottom: extraDataPanelPosition,
        duration: const Duration(
            milliseconds: Dimensions.animationDurationInMilliseconds),
        curve: Curves.fastOutSlowIn,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  extraDataPanelPosition = 0;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 1.6,
                decoration:
                    const BoxDecoration(color: Colores.background, boxShadow: [
                  BoxShadow(
                      color: Colores.shadowColor,
                      blurRadius: Dimensions.standardBlurRadius,
                      offset: Dimensions.standardOffset)
                ]),
                //Qui viene eseguito il rendering della ListView contenente i custom widget MiniCard
                //che rappresentano le previsioni per i 5 giorni successivi
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.daily.length,
                    itemBuilder: (context, index) {
                      return MiniCard(daily: widget.daily[index]);
                    }),
              ),
            ),
            //String widdget presente all'interno del pannello con le previsioni per i cinque giorni seguenti
            Positioned(
                top: 10,
                child: Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height / 80),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    '${AppLocalizations.of(context)!.standard_card_bottom_label} ${widget.searchedCityName}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colores.red,
                        fontFamily: Strings.appFontFamily,
                        fontSize: Dimensions.mediumFontSize),
                  ),
                ))
          ],
        ));
  }
}
