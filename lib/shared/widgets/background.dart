import 'package:pay_roll/shared/contants.dart';
import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  const BackgroundContainer(
      {super.key, required this.child, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          invertColors: false,
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
