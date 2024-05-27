import 'package:flutter/material.dart';
import 'package:forgottenland/theme/colors.dart';

class BlinkingCircle extends StatefulWidget {
  const BlinkingCircle({
    super.key,
    this.size = 10,
    this.color = AppColors.green,
  });

  final double size;
  final Color color;

  @override
  _BlinkingCircleState createState() => _BlinkingCircleState();
}

class _BlinkingCircleState extends State<BlinkingCircle> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _animationController,
        child: Container(
          height: widget.size,
          width: widget.size,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
