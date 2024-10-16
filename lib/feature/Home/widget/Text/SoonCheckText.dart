import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SoonCheckTextWidget extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double bottom; // bottom 값을 추가
  final double left;   // left 값을 추가

  const SoonCheckTextWidget({
    Key? key,
    required this.text,
    required this.style,
    required this.bottom,
    required this.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom, // 전달받은 bottom 값을 사용
      left: left,     // 전달받은 left 값을 사용
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
