import 'package:flutter/material.dart';

// 공통된 Text 위젯을 위한 커스텀 위젯 생성
class CustomText extends StatelessWidget {
  final String id;
  final double? size; // int?를 double?로 변경
  final TextOverflow? overflow; // overflow 속성 추가
  final int? maxLines; // maxLines 속성 추가

  const CustomText({
    Key? key,
    required this.id,
    this.size,
    this.overflow,
    this.maxLines
    //required Color,
  }) : super(key: key);
//qwe
  @override
  Widget build(BuildContext context) {
    return Text(
      id,
      style: Theme.of(context).textTheme.titleSmall?.copyWith( // 굵게
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: size,
        fontWeight: FontWeight.bold,// fontSize에 size 전달
      ),
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
