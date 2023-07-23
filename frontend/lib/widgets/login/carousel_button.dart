import 'package:flutter/material.dart';

class CarouselButton extends StatelessWidget {
  const CarouselButton({super.key, required this.direction, required this.nextSlide});

  final String direction;
  final Future<void> Function() nextSlide;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      // width: 25.0,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.white),
      alignment: Alignment.center,
      child: IconButton(
        icon: direction == 'right'
            ? const Icon(Icons.keyboard_arrow_right_rounded, size: 35.0)
            : const Icon(Icons.keyboard_arrow_left_rounded, size: 35.0),
        onPressed: nextSlide,
      ),
    );
  }
}
