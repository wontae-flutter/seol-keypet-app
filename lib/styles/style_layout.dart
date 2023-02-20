import 'package:flutter/material.dart';

class AppLayout {
  static const EdgeInsets tabContainerMargin =
      EdgeInsets.fromLTRB(20, 20, 20, 40);

  static const EdgeInsets containerInsideListviewMargin =
      EdgeInsets.symmetric(horizontal: 10);

  static const EdgeInsets registerButtonContainerPadding =
      EdgeInsets.fromLTRB(70, 20, 70, 20);

  static const EdgeInsets tabContainerPadding =
      EdgeInsets.fromLTRB(20, 20, 20, 40);
  static const EdgeInsets tabContentPadding =
      EdgeInsets.fromLTRB(30, 30, 30, 30);
  static const EdgeInsets formPageContainerPadding =
      EdgeInsets.fromLTRB(40, 20, 40, 80);
  static const EdgeInsets formPageContainerWOBottomPadding =
      EdgeInsets.fromLTRB(40, 20, 40, 0);
  static const EdgeInsets homeContentAreaPadding =
      EdgeInsets.fromLTRB(40, 20, 40, 20);
  static const EdgeInsets endDrawbarPadding =
      EdgeInsets.fromLTRB(20, 80, 20, 20);

  static const List<BoxShadow> cardBoxShadow = [
    BoxShadow(
        color: Colors.black26,
        blurRadius: 2,
        spreadRadius: 2.0,
        offset: Offset(2.0, 2.0)), // shadow direction: bottom right),
  ];
}
