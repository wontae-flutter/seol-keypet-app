import 'package:flutter/material.dart';
import '../styles/styles.dart';

class SizedElevatedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  const SizedElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.porochiLogoColor,
          fixedSize: Size(220, 60),
          alignment: Alignment.centerLeft,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
