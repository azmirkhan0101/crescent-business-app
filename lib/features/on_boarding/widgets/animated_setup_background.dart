import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../utils/gradient_tween.dart';

class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({super.key});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Gradient> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Delay before animation starts
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
    });

    _animation = GradientTween(
      begin: const LinearGradient(
        colors: [Colors.white, Colors.white],
      ),
      end: AppColors.primaryGradient,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            gradient: _animation.value,
          ),
        );
      },
    );
  }
}
