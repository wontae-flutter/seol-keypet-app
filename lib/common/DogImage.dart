import "package:flutter/material.dart";

class DogImage extends StatelessWidget {
  String image;
  DogImage({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Colors.grey[300]),
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircleAvatar(
                  // backgroundImage: NetworkImage(image),
                  backgroundImage:
                      AssetImage("assets/images/icons/pet_icon.png"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
