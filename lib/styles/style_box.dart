import 'package:flutter/material.dart';

class AppBox {
  static const BorderRadius onlyTopCircularBorder = BorderRadius.only(
    topLeft: Radius.circular(20.0),
    topRight: Radius.circular(20.0),
  );
  static const BorderRadius onlyBottomCircularBorder = BorderRadius.only(
    bottomLeft: Radius.circular(20.0),
    bottomRight: Radius.circular(20.0),
  );

  static const EdgeInsets qrButtonPadding =
      EdgeInsets.symmetric(horizontal: 40, vertical: 20);
}
