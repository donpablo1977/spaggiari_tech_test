import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaggiari_tech_test/bloc/bloc/weather_bloc.dart';
import 'package:spaggiari_tech_test/constants/colores.dart';
import 'package:spaggiari_tech_test/constants/dimensions.dart';
import 'package:spaggiari_tech_test/data/model/forecast.dart';
import 'package:spaggiari_tech_test/presentation/screens/search/parts/quote_text.dart';
import 'package:spaggiari_tech_test/presentation/screens/search/parts/search_textfield.dart';
import 'package:spaggiari_tech_test/presentation/shared_widgets/animated_loader.dart';
import 'package:spaggiari_tech_test/presentation/shared_widgets/mini_card.dart';
import 'package:spaggiari_tech_test/presentation/shared_widgets/standard_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spaggiari_tech_test/utils/utilities.dart';

import '../../../constants/strings.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //La lista serve a filtrare solo gli ultimi 5 giorni di previsioni (come da richiesta funzionale)
  //visto che il servizio restituisce l'intera settimana successiva alla data di utilizzo del servizio web
  final List<Daily> _daily = [];

  double? extraDataPanelPosition;
  String? _searchedCityName;

  void setSearchCityName(String value) {
    _searchedCityName = value;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      extraDataPanelPosition = -MediaQuery.of(context).size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.background,
      body: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: BlocConsumer<WeatherBloc, WeatherState>(
              listener: (context, state) {
            if (state is WeatherFetchedState) {
              //Viene utilizzata una lista di appoggio così da utilizzare unicamente
              //le previsioni dei 5 giorni successivi, così come da richiesta funzionale
              for (var i = 0; i < 5; i++) {
                _daily.add(state.forecast.daily![i]);
              }
            } else if (state is WeatherGecodedState) {
              //Lo state emesso per utilizzare il geocode appena ricevuto ed aggiungendo al contesto un evento
              //per il recupero dei dati meteo relativi alla città ricercata dall'utente
              context
                  .read<WeatherBloc>()
                  .add(WeatherFetchingEvent(state.geocode));
            } else if (state is WeatherFailedState) {
              //Nel caso di errore relativo al servizio di geocoding, viene mostrata una snackbar
              //attraverso l'utilizzo di un metodo statico all'interno della classe Utilities
              Utilities.showMessage(context, Colores.red,
                  AppLocalizations.of(context)!.error_message, Icons.error);
            } else if (state is WeatherGeocodeFailedState) {
              //Nel caso di una mancata risposta da parte del server, viene mostrata una snackbar
              //attraverso l'utilizzo di un metodo statico all'interno della classe Utilities
              Utilities.showMessage(
                  context,
                  Colores.red,
                  AppLocalizations.of(context)!.geocode_error_message,
                  Icons.error);
            }
          }, builder: (context, state) {
            if (state is WeatherInitial ||
                state is WeatherFailedState ||
                state is WeatherGeocodeFailedState) {
              //Lo state iniziale del widget è costituito dal TextField di ricerca
              //in cui è possibile inserire il nome di una località
              //che verrà tramutato in latitudine e longitudine così da invocare le API.
              //Tale UI viene renderizzata anche nel caso di Failed state
              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                      top: MediaQuery.of(context).size.height / 4,
                      child: SearchTextField(
                          setSearchCityNameHook: setSearchCityName)),
                  Positioned(
                      bottom: MediaQuery.of(context).size.height / 4,
                      child: const QuoteText()),
                ],
              );
            } else if (state is WeatherFetchingState) {
              //Lo state di caricamento prevede il rendering di un loader animato
              //presente negli assets con l'utilizzo della libreriua Lottie
              return AnimatedLoader(
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.width / 4,
              );
            } else if (state is WeatherFetchedState) {
              //Lo state di completamento di fetching dei dati meteo prevede il rendering
              // di uno Stack con i seguenti elementi:
              // - Text widget con stringa internazionalizzata + nome della città cercata dall'utente
              // - Standard Card widget contente diversi elementi descritti nel file relativo
              // - Extra data Panel widget con i dati relativi ai successivi 5 giorni di previsioni
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.height / 10,
                      child: Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height / 70),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          '${AppLocalizations.of(context)!.standard_card_top_label} ${_searchedCityName!}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colores.red,
                              fontFamily: Strings.appFontFamily,
                              fontSize: Dimensions.defaultFontSize),
                        ),
                      ),
                    ),
                    StandardCard(
                      state: state,
                      hook: () {
                        //Viene utilizzato il setState per modificare la posizione del pannello.
                        //In questo caso lo si è utilizzato solo per velocizzare lo sviluppo, trattandosi di un prototipo.
                        //Ovviamente, in un prodotto destinato al pubblico la scelta corretta sarebbe quella di sviluppare tutti i custom widget
                        //come oggetti rispondenti al pattern Bloc
                        setState(() {
                          extraDataPanelPosition = -30;
                        });
                      },
                      //Questo hook permette al tasto presente nella StandardCard di chiudere anche il pannello
                      //contenente le previsioni per i giorni successivi
                      forecastPanelHook: () {
                        setState(() {
                          extraDataPanelPosition =
                              -MediaQuery.of(context).size.height;
                        });
                      },
                      data: _daily,
                    ),
                    AnimatedPositioned(
                        bottom: extraDataPanelPosition,
                        duration: const Duration(
                            milliseconds:
                                Dimensions.animationDurationInMilliseconds),
                        curve: Curves.fastOutSlowIn,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width / 1.6,
                              decoration: const BoxDecoration(
                                  color: Colores.background,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colores.shadowColor,
                                        blurRadius:
                                            Dimensions.standardBlurRadius,
                                        offset: Dimensions.standardOffset)
                                  ]),
                              //Qui viene eseguito il rendering della ListView contenente i custom widget MiniCard
                              //che rappresentano le previsioni per i giorni successivi
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _daily.length,
                                  itemBuilder: (context, index) {
                                    return MiniCard(daily: _daily[index]);
                                  }),
                            ),
                            //String widget presente all'interno del pannello con le previsioni per i cinque giorni seguenti
                            Positioned(
                                top: 10,
                                child: Container(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.height / 80),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    '${AppLocalizations.of(context)!.standard_card_bottom_label} ${_searchedCityName!}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colores.red,
                                        fontFamily: Strings.appFontFamily,
                                        fontSize: Dimensions.mediumFontSize),
                                  ),
                                ))
                          ],
                        )),
                  ],
                ),
              );
            }
            return Container();
          })),
    );
  }
}
