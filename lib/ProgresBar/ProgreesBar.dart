import 'package:flutter/material.dart';

class AnimatedCircularProgressBar extends StatefulWidget {
  @override
  _AnimatedCircularProgressBarState createState() =>
      _AnimatedCircularProgressBarState();
}

class _AnimatedCircularProgressBarState
    extends State<AnimatedCircularProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _rotationAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);

    _colorAnimation = ColorTween(begin: Colors.blue, end: Colors.red)
        .animate(_animationController);

    _scaleAnimation =
        Tween<double>(begin: 1, end: 1.5).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value *
                  2 *
                  3.1416, // 2π radians = 360 degrees
              child: CircularProgressIndicator(
                value: _animationController.value,
                strokeWidth: 8,
                backgroundColor: Colors.grey,
                valueColor: _colorAnimation.value != null
                    ? AlwaysStoppedAnimation<Color?>(_colorAnimation.value)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
