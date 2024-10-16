import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String id;
  final double? size;
  final Color? color; // 색상 인자 추가

  const CustomText({
    Key? key,
    required this.id,
    this.size,
    this.color, // 색상 인자 추가
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      id,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).dialogBackgroundColor, // 색상 인자가 주어지지 않으면 기본 색상 사용
        fontWeight: FontWeight.bold,
        fontSize: size,
      ),
    );
  }
}
