import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'PetRegisterContainer.dart';
import 'PetListViewContainer.dart';
import '../../../styles/styles.dart';

class HomeArea extends StatelessWidget {
  const HomeArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.homeScreenBackgroundColor,
        borderRadius: AppBox.onlyTopCircularBorder,
      ),
      padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            QRContainer(),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PetRegisterTitle(),
                SizedBox(height: 10),
                PetListViewContainer(),
              ],
            ),
            SizedBox(height: 20),
            // Spacer(),
            PetRegisterContainer(),
          ],
        ),
      ),
    );
  }
}

class QRContainer extends StatelessWidget {
  const QRContainer({super.key});

  @override
  Widget build(BuildContext context) {
    //* OnGestureDectector()로 하면 되겠다
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("/qr_scan");
        // context.go('/qr_scan');
        print("QR 페이지로 넘어가세요!");
      },
      child: Container(
        margin: AppLayout.containerInsideListviewMargin,
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(60),
            border: Border.all(width: 1, color: Colors.black38),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  spreadRadius: 2.0,
                  offset: Offset(2.0, 2.0)), // shadow direction: bottom right),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconData(0xe4f7, fontFamily: 'MaterialIcons'),
              size: 40,
            ),
            SizedBox(width: 10),
            Text(
              "QR 확인하기",
              style: AppText.homeScreenTitle,
            ),
          ],
        ),
      ),
    );
  }
}

class PetRegisterTitle extends StatelessWidget {
  const PetRegisterTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppLayout.containerInsideListviewMargin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.pets,
            size: 45,
          ),
          SizedBox(width: 10),
          Text(
            "반려동물",
            style: AppText.homeScreenTitle,
          ),
        ],
      ),
    );
  }
}
