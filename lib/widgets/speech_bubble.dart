import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpeechBubble extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;

  const SpeechBubble({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message,
              style: GoogleFonts.rubik(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: 0,
            left: 32,
            child: CustomPaint(
              size: const Size(20, 20),
              painter: BubbleTrianglePainter(backgroundColor),
            ),
          ),
        ],
      ),
    );
  }
}

class BubbleTrianglePainter extends CustomPainter {
  final Color color;

  BubbleTrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 