import 'package:flutter/material.dart';

abstract class AppText {
  static const TextStyle homeScreenTitle =
      TextStyle(fontWeight: FontWeight.w800, fontSize: 20);

  static const TextStyle petCertificateTitle =
      TextStyle(fontWeight: FontWeight.w800, fontSize: 30);

  static const TextStyle progressFooter = TextStyle(
      color: Colors.black,
      fontSize: 20,
      height: 0.5,
      fontWeight: FontWeight.w600);

  static const TextStyle tableAccent = TextStyle(
      color: Colors.black,
      fontSize: 18,
      height: 0.5,
      fontWeight: FontWeight.w600);

  static const TextStyle tableBody = TextStyle(
      color: Colors.black,
      fontSize: 14,
      height: 0.5,
      fontWeight: FontWeight.w400);
}
