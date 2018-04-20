import 'package:flutter/material.dart';

class HollowText extends CustomPainter {
  HollowText(this.backgroundColor, this.text);

  final Color backgroundColor;
  final String text;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.largest, new Paint());

    TextSpan span = new TextSpan(
        style: new TextStyle(color: Colors.black, fontSize: 96.0), text: text);
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);

    tp.layout();
    tp.paint(canvas, new Offset(size.width / 2, size.height / 2));

    canvas.drawColor(backgroundColor, BlendMode.srcOut);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
