import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pay_roll/shared/contants.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  const LoadingWidget({super.key, this.size = 50.0});

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      color: primaryColor,
      size: size,
    );
  }
}
