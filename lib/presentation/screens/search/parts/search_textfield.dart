import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spaggiari_tech_test/constants/dimensions.dart';
import '../../../../bloc/bloc/weather_bloc.dart';
import '../../../../constants/colores.dart';
import '../../../../constants/strings.dart';

class SearchTextField extends StatefulWidget {
  final Function setSearchCityNameHook;
  const SearchTextField({Key? key, required this.setSearchCityNameHook})
      : super(key: key);

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final TextEditingController _tec = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String? _hintText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _hintText = AppLocalizations.of(context)!.searchtext_hint;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        focusNode: _focusNode,
        onTap: () {
          setState(() {
            _hintText = '';
          });
          _tec.clear();
          context.read<WeatherBloc>().add(WeatherStartingEvent());
        },
        onSubmitted: (value) {
          if (value.trim() != '') {
            widget.setSearchCityNameHook(value);
            context.read<WeatherBloc>().add(WeatherGeocodingEvent(value));
          }
        },
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: Dimensions.hugeFontSize,
            color: Colores.red,
            fontFamily: Strings.appFontFamily),
        controller: _tec,
        autocorrect: false,
        cursorColor: Colores.red.withAlpha(2),
        cursorWidth: 20,
        cursorRadius: Radius.zero,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: _hintText,
          hintMaxLines: 4,
          hintStyle: TextStyle(
              fontSize: Dimensions.defaultFontSize,
              fontFamily: Strings.appFontFamily,
              color: Colores.red.withAlpha(120)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
