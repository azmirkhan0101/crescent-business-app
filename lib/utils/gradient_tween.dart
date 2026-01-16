import 'package:flutter/cupertino.dart';

class GradientTween extends Tween<Gradient> {
  GradientTween({required Gradient begin, required Gradient end})
      : super(begin: begin, end: end);

  @override
  Gradient lerp(double t) {
    if (begin is LinearGradient && end is LinearGradient) {
      return LinearGradient(
        begin: (begin as LinearGradient).begin,
        end: (begin as LinearGradient).end,
        stops: (begin as LinearGradient).stops,
        transform: (begin as LinearGradient).transform,
        colors: List.generate(
          (begin as LinearGradient).colors.length,
              (i) => Color.lerp(
            (begin as LinearGradient).colors[i],
            (end as LinearGradient).colors[i],
            t,
          )!,
        ),
      );
    }
    return end!;
  }
}
