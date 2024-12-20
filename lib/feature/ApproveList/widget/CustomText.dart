import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String id;
  final double? size;
  final Color? color; // 색상 인자 추가
  final TextOverflow? overflow; // overflow 속성 추가
  final int? maxLines; // maxLines 속성 추가

  const CustomText({
    Key? key,
    required this.id,
    this.size,
    this.color, // 색상 인자 추가
    this.overflow,
    this.maxLines
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      id,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: color ?? Theme.of(context).colorScheme.inverseSurface, // 색상이 주어지지 않으면 기본 색상 사용
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}