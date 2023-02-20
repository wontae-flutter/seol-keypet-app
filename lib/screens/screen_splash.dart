import "dart:async";
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import "../../../styles/styles.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      // context.go("/home");
      Navigator.of(context).pushReplacementNamed("/home");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColor.porochiLogoColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo/keypet_rect.png",
                  width: 240,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 10),
                Text(
                  "",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
