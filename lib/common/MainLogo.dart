import "package:flutter/material.dart";
import '../../../styles/styles.dart';

class MainLogo extends StatelessWidget {
  const MainLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        // decoration: BoxDecoration(
        //   color: AppColor.porochiLogoColor,
        //   borderRadius: BorderRadius.circular(6),
        // ),
        // width: 100,
        // height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo/keypet_circle.png",
              fit: BoxFit.fitHeight,
              width: 80,
              height: 80,
            ),
            SizedBox(width: 10),
            // Text(
            //   "KEYPET",
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Colors.white,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
