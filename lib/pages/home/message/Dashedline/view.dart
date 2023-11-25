import 'package:flutter/material.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';
// constants
// import 'package:packet_app/constants/color.dart';

// 虚线
class DottedLineDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double indent;
  final double endIndent;

  const DottedLineDivider({
    this.height = 1.0,
    this.color = Colors.black,
    this.indent = 0.0,
    this.endIndent = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedLinePainter(
        color: color,
        strokeWidth: height,
      ),
      child: Container(
        height: height,
        margin: EdgeInsets.only(left: indent, right: endIndent),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  DottedLinePainter({
    this.color = Colors.black,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    var startX = 0.0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DottedLinePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(DottedLinePainter oldDelegate) => false;
}
