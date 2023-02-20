import "package:flutter/material.dart";

class Copywrite extends StatelessWidget {
  const Copywrite({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Copyright(c) KetPet All Rights Reserved.",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey),
    );
  }
}
