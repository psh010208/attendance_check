import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogUpButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  LogUpButton({
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 22.sp, // 반응형 폰트 크기
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant, // 테마에서 가져온 기본 배경색
        foregroundColor: Theme.of(context).colorScheme.onPrimary, // 테마에서 가져온 기본 텍스트 색상
        minimumSize: Size(190.w, 50.h), // 반응형 버튼 크기
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
