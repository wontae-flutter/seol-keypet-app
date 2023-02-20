import 'package:flutter/material.dart';
import 'package:porocci_main/styles/styles.dart';
import "../common/commons.dart";

class QRResultScreen extends StatelessWidget {
  const QRResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final barcodeInfoObject = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
          shape: Border(bottom: BorderSide(color: Colors.black26)),
          title: Text("QR 인식 결과")),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 53),
            DogImage(image: "image"),
            SizedBox(height: 60),
            Text("QR 인식 결과", style: AppText.tableAccent),
            SizedBox(height: 5),
            Text(barcodeInfoObject["barcodeInfo"]),
            SizedBox(height: 15),
            SizedElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("/qr_scan");
                },
                child: Text("QR 다시 찍기")),
            SizedElevatedButton(onPressed: () {}, child: Text("주인에게 전화 걸기")),
            SizedElevatedButton(onPressed: () {}, child: Text("홈으로 돌아가기")),
          ],
        ),
      ),
    );
  }
}
