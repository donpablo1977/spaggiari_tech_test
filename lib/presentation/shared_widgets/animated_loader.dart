import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedLoader extends StatelessWidget {
  final double? width;
  final double? height;

  const AnimatedLoader({Key? key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LottieBuilder.asset(
      'assets/animations/loader.json',
      width: width ?? 50,
      height: height ?? 50,
    );
  }
}
