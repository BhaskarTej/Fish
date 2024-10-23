// lib/fish.dart
import 'package:flutter/material.dart';

class Fish {
  final Color color;
  final double speed;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  Fish({required this.color, required this.speed});

  Widget buildFish() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _animation.value,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  void startSwimming(TickerProvider vsync) {
    _controller = AnimationController(
      duration: Duration(seconds: (3 / speed).round()),
      vsync: vsync,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(100, 100), // Customize the end position as needed
    ).animate(_controller);

    _controller.repeat(reverse: true);
  }
}
