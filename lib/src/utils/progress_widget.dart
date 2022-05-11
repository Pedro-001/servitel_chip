
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProgressWidget extends StatelessWidget {

  final double width;
  final double height;

  const ProgressWidget({
    Key key,
    this.width = 100,
    this.height = 100
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'lottie/loader.json',
        width: this.width,
        height: this.height,
      )
    );
  }
}
