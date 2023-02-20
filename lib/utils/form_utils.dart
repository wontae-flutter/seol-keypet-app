import "package:flutter/material.dart";
import '../styles/styles.dart';

Future<bool> onWillPopp(BuildContext context, bool _formChanged) {
  if (!_formChanged) return Future<bool>.value(true);
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text("입력을 중지하시겠습니까?\n입력 중인 모든 정보가 사라집니다."),
        actions: <Widget>[
          TextButton(
            child: Text("계속"),
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: AppColor.porochiLogoColor,
            ),
          ),
          TextButton(
            child: Text("입력 중지"),
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
