import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final double containerSize;
  final double titleFontSize;

  const HeaderWidget({
    super.key,
    this.title = 'Chuyển Tiền Cho Thanh',
    this.subtitle = 'Nhanh chóng & Tiện lợi',
    this.emoji = '💰',
    this.containerSize = 80,
    this.titleFontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon Container
        Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF667eea).withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(emoji, style: TextStyle(fontSize: containerSize * 0.5)),
          ),
        ),
        SizedBox(height: 15),

        // Title
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),

        // Subtitle
        Text(
          subtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
        ),
      ],
    );
  }
}
