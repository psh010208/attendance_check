import 'package:flutter/material.dart';

// 공통된 Text 위젯을 위한 커스텀 위젯 생성
class CustomText extends StatelessWidget {
  final String id;

  const CustomText({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      id,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold, // 굵게
          color: Colors.white, // 텍스트 색상
          fontSize: 21
        )

    );
  }
}
