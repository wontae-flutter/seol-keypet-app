import 'package:flutter/material.dart';
import "../../../styles/styles.dart";

//! 이거 회원가입에도 있어야하는거 아냐?
class ThirdPartyIconContainer extends StatelessWidget {
  const ThirdPartyIconContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                color: AppColor.grey,
                height: 1,
              ),
            ),
            SizedBox(width: 15),
            Text(
              "SNS 계정으로 로그인하기",
              style: TextStyle(color: AppColor.grey),
            ),
            SizedBox(width: 15),
            Flexible(
              flex: 1,
              child: Container(
                color: AppColor.grey,
                height: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _thirdPartyIcon("assets/images/auth_icons/google.png", () {}),
            _thirdPartyIcon("assets/images/auth_icons/kakao.png", () {}),
            _thirdPartyIcon("assets/images/auth_icons/naver.png", () {}),
          ],
        ),
      ],
    );
  }

  Widget _thirdPartyIcon(imagePath, callback) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
          onTap: callback,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              width: 60,
              height: 60,
            ),
          ),
        ));
  }
}
