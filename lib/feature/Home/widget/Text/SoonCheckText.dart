import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SoonCheckText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double leftOffset;

  const SoonCheckText({Key? key, required this.text, required this.style, required this.leftOffset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0, // 나중에 상위 위젯에서 위치 조정
      left: leftOffset.w, // 위치 조정
      child: Text(
        text,
        style: style,
      ),
    );
  }
}