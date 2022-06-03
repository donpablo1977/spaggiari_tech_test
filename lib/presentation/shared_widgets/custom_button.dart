import 'package:flutter/material.dart';
import 'package:spaggiari_tech_test/constants/dimensions.dart';
import '../../constants/colores.dart';

class CustomButton extends StatefulWidget {
  final Function hook;
  final IconData iconData;
  final double? width;
  final double? height;
  const CustomButton(
      {Key? key,
      required this.hook,
      required this.iconData,
      this.width,
      this.height})
      : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      //Viene utilizzato un widget Ink con una combinazione di InkWell
      //per visualizzare lo splashColor altrimenti presente sotto al container
      child: Ink(
        width: widget.width ?? MediaQuery.of(context).size.width / 12,
        height: widget.height ?? MediaQuery.of(context).size.width / 12,
        decoration: const BoxDecoration(
          color: Colores.red,
          shape: BoxShape.circle,
        ),
        child: InkWell(
          splashColor: Colors.white.withAlpha(150),
          highlightColor: Colors.transparent,
          onTap: () {
            widget.hook();
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 8,
            height: MediaQuery.of(context).size.width / 8,
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                  blurRadius: 3,
                  color: Colores.shadowColor,
                  offset: Dimensions.standardOffset)
            ], borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Icon(
              widget.iconData,
              color: Colors.white,
              size: 12,
            ),
          ),
        ),
      ),
    );
  }
}
