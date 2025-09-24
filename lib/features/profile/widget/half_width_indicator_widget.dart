import 'package:flutter/material.dart';

class HalfTabIndicator extends Decoration {
  final Color color;
  final double thickness;

  const HalfTabIndicator({
    this.color = Colors.black,
    this.thickness = 2.0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _HalfPainter(color, thickness);
  }
}

class _HalfPainter extends BoxPainter {
  final Color color;
  final double thickness;

  _HalfPainter(this.color, this.thickness);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    final double tabWidth = cfg.size!.width;
    final double lineWidth = tabWidth / 2; // ✅ half of tab width
    final double startX = offset.dx + (tabWidth - lineWidth) / 2;
    final double endX = startX + lineWidth;
    final double y = offset.dy + cfg.size!.height - thickness / 2;

    canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);
  }
}
